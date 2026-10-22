package main

import (
	"embed"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"slices"
	"strings"
	"syscall"
)

const (
	schemesDir    = "/etc/profiles/per-user/zero/share/themes"
	defaultScheme = "catppuccin-mocha"
	reloadProcess = "kitty"
)

// matugenBin is set at build time; falls back to PATH for go run.
var matugenBin = "matugen"

//go:embed templates
var templates embed.FS

var (
	paletteRe = regexp.MustCompile(`(?m)^\s+(base[0-9A-F]{2}):\s*"?#?([0-9a-fA-F]{6})"?`)
	nameRe    = regexp.MustCompile(`(?m)^name:\s*"?([^"\n]+?)"?\s*$`)
	authorRe  = regexp.MustCompile(`(?m)^author:\s*"?([^"\n]+?)"?\s*$`)
	imageRe   = regexp.MustCompile(`/[^\s]+\.(?:jpg|jpeg|png|gif)`)
	modeRe    = regexp.MustCompile(`"mode":"([a-z]+)"`)
	schemeRe  = regexp.MustCompile(`"scheme":"([^"]+)"`)
)

var state = stateDir()

func stateDir() string {
	if d := os.Getenv("XDG_STATE_HOME"); d != "" {
		return filepath.Join(d, "theme")
	}
	return filepath.Join(os.Getenv("HOME"), ".local", "state", "theme")
}

func statePath(name string) string { return filepath.Join(state, name) }

func firstMatch(re *regexp.Regexp, s string) string {
	if m := re.FindStringSubmatch(s); m != nil {
		return strings.TrimSpace(m[1])
	}
	return ""
}

// render substitutes {{base00-hex}} placeholders in an embedded base16 template.
func render(scheme []byte, templateFile string) (string, error) {
	tmpl, err := templates.ReadFile(templateFile)
	if err != nil {
		return "", err
	}

	matches := paletteRe.FindAllStringSubmatch(string(scheme), -1)
	pairs := make([]string, 0, len(matches)*2+4)
	for _, m := range matches {
		pairs = append(pairs, "{{"+m[1]+"-hex}}", strings.ToLower(m[2]))
	}
	pairs = append(pairs,
		"{{scheme-name}}", firstMatch(nameRe, string(scheme)),
		"{{scheme-author}}", firstMatch(authorRe, string(scheme)),
	)
	return strings.NewReplacer(pairs...).Replace(string(tmpl)), nil
}

func apply(mode, message string) error {
	if err := os.WriteFile(statePath("current.json"), []byte(mode+"\n"), 0o644); err != nil {
		return err
	}
	reload()
	fmt.Println("theme:", message)
	return nil
}

func reload() {
	entries, err := os.ReadDir("/proc")
	if err != nil {
		return
	}
	for _, e := range entries {
		comm, err := os.ReadFile(filepath.Join("/proc", e.Name(), "comm"))
		if err != nil || strings.TrimSpace(string(comm)) != reloadProcess {
			continue
		}
		var pid int
		if _, err := fmt.Sscanf(e.Name(), "%d", &pid); err == nil {
			_ = syscall.Kill(pid, syscall.SIGUSR1)
		}
	}
}

func setScheme(name string) error {
	scheme, err := os.ReadFile(filepath.Join(schemesDir, name+".yaml"))
	if errors.Is(err, fs.ErrNotExist) {
		return fmt.Errorf("no such scheme: %s (try: theme list)", name)
	} else if err != nil {
		return err
	}
	out, err := render(scheme, "templates/kitty.mustache")
	if err != nil {
		return err
	}
	if err := os.WriteFile(statePath("kitty-colors.conf"), []byte(out), 0o644); err != nil {
		return err
	}
	return apply(fmt.Sprintf(`{"mode":"static","scheme":"%s"}`, name), name)
}

// currentWallpaper reads the path awww last displayed; its cache is not text.
func currentWallpaper() string {
	var found string
	root := filepath.Join(os.Getenv("HOME"), ".cache", "awww")
	_ = filepath.WalkDir(root, func(path string, d fs.DirEntry, err error) error {
		if err != nil || d.IsDir() {
			return nil
		}
		data, err := os.ReadFile(path)
		if err != nil {
			return nil
		}
		if m := imageRe.FindString(strings.ReplaceAll(string(data), "\x00", " ")); m != "" {
			found = m
			return filepath.SkipAll
		}
		return nil
	})
	return found
}

func matugenConfig() (string, error) {
	tmpl, err := templates.ReadFile("templates/kitty-matugen.conf")
	if err != nil {
		return "", err
	}
	tmplPath := statePath("kitty-matugen.conf")
	if err := os.WriteFile(tmplPath, tmpl, 0o644); err != nil {
		return "", err
	}
	conf := fmt.Sprintf("[config]\n\n[templates.kitty]\ninput_path = %q\noutput_path = %q\n",
		tmplPath, statePath("kitty-colors.conf"))
	confPath := statePath("matugen.toml")
	return confPath, os.WriteFile(confPath, []byte(conf), 0o644)
}

func setAuto(image string) error {
	if image == "" {
		if image = currentWallpaper(); image == "" {
			return errors.New("no wallpaper found; usage: theme auto [image]")
		}
	}
	conf, err := matugenConfig()
	if err != nil {
		return err
	}
	cmd := exec.Command(matugenBin, "-c", conf, "image", image, "--prefer", "saturation")
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("matugen: %w", err)
	}
	return apply(fmt.Sprintf(`{"mode":"auto","wallpaper":"%s"}`, image), "auto from "+filepath.Base(image))
}

// restore re-applies whatever mode was last recorded, so a rebuild keeps it.
func restore() error {
	data, err := os.ReadFile(statePath("current.json"))
	if err != nil {
		return setScheme(defaultScheme)
	}
	switch firstMatch(modeRe, string(data)) {
	case "auto":
		if err := setAuto(""); err == nil {
			return nil
		}
	case "static":
		if name := firstMatch(schemeRe, string(data)); name != "" {
			return setScheme(name)
		}
	}
	return setScheme(defaultScheme)
}

func list() error {
	entries, err := os.ReadDir(schemesDir)
	if err != nil {
		return err
	}
	names := make([]string, 0, len(entries))
	for _, e := range entries {
		if name, ok := strings.CutSuffix(e.Name(), ".yaml"); ok {
			names = append(names, name)
		}
	}
	slices.Sort(names)
	fmt.Println(strings.Join(names, "\n"))
	return nil
}

func current() error {
	data, err := os.ReadFile(statePath("current.json"))
	if err != nil {
		data = []byte(`{"mode":"none"}` + "\n")
	}
	fmt.Print(string(data))
	return nil
}

func run(args []string) error {
	cmd := ""
	if len(args) > 0 {
		cmd, args = args[0], args[1:]
	}
	switch {
	case cmd == "set" && len(args) == 1:
		return setScheme(args[0])
	case cmd == "auto" && len(args) <= 1:
		return setAuto(strings.Join(args, ""))
	case cmd == "restore" && len(args) == 0:
		return restore()
	case cmd == "list" && len(args) == 0:
		return list()
	case cmd == "current" && len(args) == 0:
		return current()
	}
	return errors.New("usage: theme set <scheme> | theme auto [image] | theme restore | theme list | theme current")
}

func main() {
	if err := os.MkdirAll(state, 0o755); err != nil {
		fmt.Fprintln(os.Stderr, "theme:", err)
		os.Exit(1)
	}
	if err := run(os.Args[1:]); err != nil {
		fmt.Fprintln(os.Stderr, "theme:", err)
		os.Exit(1)
	}
}
