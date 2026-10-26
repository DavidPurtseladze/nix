package main

import (
	"embed"
	"encoding/json"
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

// curated schemes offered by the picker; "palettes all" dumps every installed one
var featured = []string{
	"catppuccin-mocha", "catppuccin-macchiato", "catppuccin-frappe", "catppuccin-latte",
	"gruvbox-dark-hard", "gruvbox-light-hard", "nord", "onedark", "dracula",
	"tokyo-night-dark", "everforest", "rose-pine", "solarized-dark", "kanagawa",
	"monokai", "ayu-dark",
}

// matugenBin is set at build time; falls back to PATH for go run.
var matugenBin = "matugen"

//go:embed templates
var templates embed.FS

var (
	paletteRe    = regexp.MustCompile(`(?m)^\s+(base[0-9A-F]{2}):\s*"?#?([0-9a-fA-F]{6})"?`)
	nameRe       = regexp.MustCompile(`(?m)^name:\s*"?([^"\n]+?)"?\s*$`)
	authorRe     = regexp.MustCompile(`(?m)^author:\s*"?([^"\n]+?)"?\s*$`)
	imageRe      = regexp.MustCompile(`/[^\s]+\.(?:jpg|jpeg|png|gif)`)
	modeRe       = regexp.MustCompile(`"mode":"([a-z]+)"`)
	schemeRe     = regexp.MustCompile(`"scheme":"([^"]+)"`)
	kittyColorRe = regexp.MustCompile(`(?m)^(background|foreground|color\d+)\s+(#[0-9a-fA-F]{6})`)
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

	// hyprland re-reads its config, picking up palette.lua
	_ = exec.Command("hyprctl", "reload").Run()
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
	publishPalette(paletteFromKitty())
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
	publishPalette(paletteFromKitty())
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

// paletteFromKitty reads the palette that is currently applied back out of the
// generated kitty colours, so matugen output and base16 schemes look the same
// to anything that consumes it.
func paletteFromKitty() map[string]string {
	kitty := map[string]string{}
	data, err := os.ReadFile(statePath("kitty-colors.conf"))
	if err == nil {
		for _, m := range kittyColorRe.FindAllStringSubmatch(string(data), -1) {
			kitty[m[1]] = strings.ToLower(m[2])
		}
	}
	pick := func(key, fallback string) string {
		if v, ok := kitty[key]; ok {
			return v
		}
		return fallback
	}
	return map[string]string{
		"base00": pick("background", "#1e1e2e"),
		"base01": pick("color0", "#313244"),
		"base02": pick("color8", "#45475a"),
		"base03": pick("color8", "#6c7086"),
		"base04": pick("color7", "#a6adc8"),
		"base05": pick("foreground", "#cdd6f4"),
		"base06": pick("foreground", "#f5e0dc"),
		"base07": pick("color15", "#b4befe"),
		"base08": pick("color1", "#f38ba8"),
		"base09": pick("color9", "#fab387"),
		"base0A": pick("color3", "#f9e2af"),
		"base0B": pick("color2", "#a6e3a1"),
		"base0C": pick("color6", "#94e2d5"),
		"base0D": pick("color4", "#89b4fa"),
		"base0E": pick("color5", "#f5c2e7"),
		"base0F": pick("color14", "#94e2d5"),
	}
}

// autoEntry is the picker's "follow the wallpaper" tile.
func autoEntry() map[string]string {
	p := paletteFromKitty()
	p["scheme"] = "auto"
	p["name"] = "Auto - matugen"
	return p
}

// writeGtkCSS renders the palette into the stylesheet that gtk.nix imports
// from both gtk-3.0/gtk.css and gtk-4.0/gtk.css.
func writeGtkCSS(p map[string]string) {
	tmpl, err := templates.ReadFile("templates/gtk.css")
	if err != nil {
		return
	}
	pairs := make([]string, 0, len(p)*2)
	for k, v := range p {
		pairs = append(pairs, "{{"+k+"}}", v)
	}
	out := strings.NewReplacer(pairs...).Replace(string(tmpl))
	_ = os.WriteFile(statePath("gtk-colors.css"), []byte(out), 0o644)
}

// publishPalette writes the active colours where any UI can read them: JSON for
// the Quickshell pickers, Lua for the Hyprland config, CSS for GTK apps.
func publishPalette(p map[string]string) {
	if data, err := json.MarshalIndent(p, "", " "); err == nil {
		_ = os.WriteFile(statePath("palette.json"), append(data, '\n'), 0o644)
	}

	keys := make([]string, 0, len(p))
	for k := range p {
		keys = append(keys, k)
	}
	slices.Sort(keys)

	var lua strings.Builder
	lua.WriteString("return {\n")
	for _, k := range keys {
		fmt.Fprintf(&lua, "  %s = %q,\n", k, p[k])
	}
	lua.WriteString("}\n")
	_ = os.WriteFile(statePath("palette.lua"), []byte(lua.String()), 0o644)

	writeGtkCSS(p)
}

// palettes prints the schemes as JSON for the picker UI to render.
func palettes(all bool) error {
	names := featured
	if all {
		entries, err := os.ReadDir(schemesDir)
		if err != nil {
			return err
		}
		names = nil
		for _, e := range entries {
			if n, ok := strings.CutSuffix(e.Name(), ".yaml"); ok {
				names = append(names, n)
			}
		}
		slices.Sort(names)
	}

	out := make([]map[string]string, 0, len(names)+1)
	out = append(out, autoEntry())
	for _, name := range names {
		data, err := os.ReadFile(filepath.Join(schemesDir, name+".yaml"))
		if err != nil {
			continue // a curated scheme missing from this nixpkgs is not fatal
		}
		p := map[string]string{"scheme": name, "name": firstMatch(nameRe, string(data))}
		for _, m := range paletteRe.FindAllStringSubmatch(string(data), -1) {
			p[m[1]] = "#" + strings.ToLower(m[2])
		}
		out = append(out, p)
	}

	enc := json.NewEncoder(os.Stdout)
	enc.SetIndent("", " ")
	return enc.Encode(out)
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
	case cmd == "palettes" && len(args) <= 1:
		return palettes(len(args) == 1 && args[0] == "all")
	case cmd == "list" && len(args) == 0:
		return list()
	case cmd == "current" && len(args) == 0:
		return current()
	}
	return errors.New("usage: theme set <scheme> | theme auto [image] | theme restore | theme list | theme palettes [all] | theme current")
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
