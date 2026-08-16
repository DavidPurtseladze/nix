# TODO

## System essentials — real gaps (checked against what's actually installed)

- [ ] **File manager** — not installed at all. `thunar` only exists as dead text
      in a workspace icon-matching regex (`lib/wayland/workspaces.nix`), not an
      actual package. No GUI way to browse files right now.
- [ ] **Clipboard history** — `wl-clipboard` works (basic copy/paste), but
      `clipman` (history) is only in a *commented-out* `exec-once` line in
      `hyprland.nix` — never actually installed.
- [ ] **Polkit agent** — not installed/enabled anywhere. This is what shows the
      graphical "enter password to allow this" prompt some apps need. More
      relevant now that Docker/blueman are enabled, which occasionally trigger
      privileged actions.
- [ ] **xdg-desktop-portal-hyprland** — not installed. Needed for screen-sharing
      in browsers/Discord/Zoom ("share screen" silently fails without it) and
      proper file-picker dialogs in sandboxed apps.
- [ ] **Screenshot keybind** — `grim`+`slurp` are installed, but nothing binds
      them to a key right now — no way to take a screenshot without typing the
      command by hand.

Minor/cosmetic, no action needed unless relevant: `windowrule`s already
anticipate Telegram/Slack/Discord (`match:class
^(org.telegram.desktop|Slack|discord|vesktop)$`) but none of those are
installed — harmless dead rules, only matters if one of them gets installed
later.

## Nice-to-haves (more subjective, lower priority than the gaps above)

- [ ] `mpv` — lightweight video player
- [ ] PDF/image viewer
- [ ] Telegram/Discord — whichever you actually use, since the window rules
      are already primed for them

## Dev environments — PHP/Node versioning

Nix doesn't need a version manager the way nvm/phpenv work. Every version of
every package lives in its own immutable, content-addressed store path
(`/nix/store/abc123-php-7.4.33`, `/nix/store/def456-php-8.3.11`) - they
already coexist on disk with zero conflict, always, by construction. The only
place conflicts happen is putting two of them **on the same PATH at the same
time** (both claiming `php`).

The standard Nix pattern is **per-project dev shells**, not a global
switcher. Each project gets its own `shell.nix`/`flake.nix` declaring exactly
which version it needs:

```nix
# project-a/shell.nix — needs PHP 7.4
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell { packages = [ pkgs.php74 ]; }
```

```nix
# project-b/shell.nix — needs PHP 8.3
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell { packages = [ pkgs.php83 ]; }
```

`cd project-a && nix-shell` → only `php74` on PATH. `cd project-b && nix-shell`
→ only `php83`. They never touch each other - it's not a "switch," it's just
which shell you're currently in. Nixpkgs ships versioned attribute names for
both: `php74`/`php81`/`php82`/`php83`/`php84` and
`nodejs_18`/`nodejs_20`/`nodejs_22`/`nodejs_24` (exact set shifts as old
versions go EOL and get dropped).

Putting both `pkgs.php74` and `pkgs.php83` into global `home.packages` instead
would fail the build with a **collision error** - both provide `bin/php`, and
unlike per-project shells, `home.packages` puts everything on one shared PATH
permanently. Per-project shells never hit this.

Most people also pair this with **direnv** (`.envrc` containing `use flake` or
`use nix`) so the right shell auto-activates the instant you `cd` into a
project directory - no manually typing `nix-shell` every time.

- [ ] Set up direnv in home-manager config
- [ ] Drop a reusable PHP/Node dev-shell template into this repo to copy into
      new projects
