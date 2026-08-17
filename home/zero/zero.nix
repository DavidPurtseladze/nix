{ config, ... }: { 
    imports = [ 
        ./home.nix 
        ../common
        ../features/cli
        ../features/desktop
        ../features/apps
    ]; 

    features = {
        cli = {
            zsh.enable = true;
            starship.enable = true;
            tmux.enable = true;
            fzf.enable = true;
            fastfetch.enable = true;
            lazygit.enable = true;
            lazydocker.enable = true;
            claude-code.enable = true;
        };
        desktop = {
            wayland.enable = true;
            hyprland.enable = true;
            fonts.enable = true;
            hyprpaper.enable = true;
            wlogout.enable = true;
            rofi.enable = true;
            hyprlock.enable = true;
            hypridle.enable = true;
            swaync.enable = true;
            thunar.enable = true;
            gtk.enable = true;
            media.enable = true;
        };
        apps = {
            kitty.enable = true;
        };
    };
}
