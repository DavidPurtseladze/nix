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
                userName = "David Purtseladze";
                userEmail = "dphurtseladze@gmail.com";
            };
            # TODO: Activate Once 1password is set up
            # ssh = {
            #     enable = true;
            #     onePasswordAgent.enable = true;
            # };
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
            media.enable = true;
            cursor = {
                enable = true;
                softwareCursors = true;
            };
        };
        apps = {
            kitty.enable = true;
            phpstorm.enable = false;
            telegram.enable = true;
            slack.enable = true;
            obsidian.enable = true;
            discord.enable = true;
            hydralauncher.enable = true;
        };
    };
}
