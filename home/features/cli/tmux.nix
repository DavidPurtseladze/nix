{
    config,
    lib,
    pkgs,
    ...
}:
with lib;
let 
    cfg = config.features.cli.tmux;
    catppuccin-v2 = pkgs.tmuxPlugins.catppuccin.overrideAttrs (_: rec {
        version = "2.1.3";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "tmux";
          rev = "v${version}";
          hash = "sha256-Is0CQ1ZJMXIwpDjrI5MDNHJtq+R3jlNcd9NXQESUe2w=";   
        };
      });
in {
    options.features.cli.tmux.enable = mkEnableOption "Enable Tmux and configure Tmux";

    config = mkIf cfg.enable {
        programs.tmux = {
            enable = true;

            prefix = "C-Space";
            escapeTime = 10;
            historyLimit = 10000;
            baseIndex = 1;

            extraConfig = ''
                unbind C-b

                # Mouse support
                set -g mouse on

                set -g allow-rename off
                set -g renumber-windows on

                set -g pane-border-style "fg=#585b70"
                set -g pane-active-border-style "fg=#89b4fa"

                set -g window-status-format "#I:#W"
                set -g window-status-current-format "#[fg=#89b4fa,bold] #I:#W "

                # Pane movement (Colemak)
                bind n select-pane -L
                bind e select-pane -D
                bind i select-pane -U
                bind o select-pane -R

                # Pane movement (arrows)
                bind Left  select-pane -L
                bind Down  select-pane -D
                bind Up    select-pane -U
                bind Right select-pane -R

                # Resize panes (Colemak)
                bind -r N resize-pane -L 5
                bind -r E resize-pane -D 5
                bind -r I resize-pane -U 5
                bind -r O resize-pane -R 5

                # Resize panes (arrow keys)
                bind -r Left  resize-pane -L 5
                bind -r Down  resize-pane -D 5
                bind -r Up    resize-pane -U 5
                bind -r Right resize-pane -R 5

                # Use vi keys in copy mode
                set-window-option -g mode-keys vi

                # Start selection with v
                bind -T copy-mode-vi v send-keys -X begin-selection

                # Copy selection with y
                bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"

                # Split panes
                bind | split-window -h
                bind - split-window -v

                # Keep current directory when splitting
                bind | split-window -h -c "#{pane_current_path}"
                bind - split-window -v -c "#{pane_current_path}"
            '';

            plugins = with pkgs.tmuxPlugins; [
                {
                    plugin = resurrect;
                }
                {
                    plugin = continuum;
                    extraConfig = ''
                        set -g @continuum-restore 'on'
                        set -g @continuum-save-interval '15'
                    '';
                }
                {
                    plugin = yank;
                }
                {
                    plugin = catppuccin-v2;
                    extraConfig = ''
                        set -g @catppuccin_flavor "mocha"
                        set -g @catppuccin_window_status_style "rounded"
                        set -g @catppuccin_window_number_position "left"

                        set -g @catppuccin_window_text " #W"
                        set -g @catppuccin_window_current_text " #W"

                        set -g status-position bottom
                        set -g status-left ""
                        set -g status-right-length 100
                        set -g status-justify left

                        set -g status-right "#{E:@catppuccin_status_application}"
                        set -ag status-right "#{E:@catppuccin_status_session}"
                        set -ag status-right "#{E:@catppuccin_status_uptime}"
                    '';
                }
            ];
        };
    };
}
