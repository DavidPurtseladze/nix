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
            neovim.enable = true;
            git = {
                enable = true;
                userName = "nik-a73";
                userEmail = "nick.kublashvili@gmail.com";
            };
            ssh = {
                enable = true;
                onePasswordAgent.enable = true;
            };
            misc = {
                eza.enable = true;
                bat.enable = true;
                zoxide.enable = true;
                extras.enable = true;
            };
        };
        desktop = {
            wayland.enable = true;
            hyprland = {
                enable = true;
                pushToTalk.enable = true;
            };
            fonts.enable = true;
            awww = {
                enable = true;
                defaultWallpaper = ../features/desktop/assets/wallpapers/purple-tree.jpg;
            };
            wlogout.enable = true;
            rofi.enable = true;
            hyprlock.enable = true;
            hypridle.enable = true;
            swaync.enable = true;
            thunar.enable = true;
            gtk.enable = true;
            cursor = {
                enable = true;
                # nouveau drops the cursor plane when the screen goes static.
                # Retest after the reboot onto the NVIDIA driver.
                softwareCursors = true;
            };
            media.enable = true;
        };
        apps = {
            kitty = {
                enable = true;
                # Default 3.0 was hiding the pointer while reading output.
                mouseHideWait = "15.0";
            };
            phpstorm.enable = false;
            telegram.enable = true;
            slack.enable = true;
            obsidian.enable = true;
            discord.enable = true;
            hydralauncher.enable = true;
        };
    };
}
