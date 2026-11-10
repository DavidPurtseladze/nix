{ config, ... }: { 
    imports = [ 
        ./home.nix 
        ../common
        ../features/cli
        ../features/desktop
        ../features/apps
        ../features/sdks
        ./features/cli/projects.nix
        ./features/cli/git.nix
        ./features/cli/ssh.nix
        ./features/cli/powershell.nix
        ./features/apps/kitty.nix
        ./features/apps/fastfetch.nix
        ./features/apps/theme.nix
        ./features/apps/wallpaper-ui.nix
    ];

    features = {
        cli = {
            zsh.enable = true;
            starship.enable = true;
            tmux.enable = true;
            fzf.enable = true;
            fastfetch.enable = false;
            lazygit.enable = true;
            lazydocker.enable = true;
            claude-code.enable = true;
            neovim.enable = true;
            powershell.enable = true;
            git = {
                enable = true;
                userName = "David Purtseladze";
                userEmail = "dphurtseladze@gmail.com";
            };
            ssh.enable = true;
            sing-box.enable = true;
            kubectl.enable = true;
            postgresql.enable = true;
            lazysql.enable = true;
            misc = {
                eza.enable = true;
                bat.enable = true;
                zoxide.enable = true;
                extras.enable = true;
            };
        };
        desktop = {
            hyprland = {
                enable = true;
            };
            fonts.enable = true;
            awww = {
                enable = true;
                defaultWallpaper = ../../config/assets/wallpapers/purple-tree.jpg;
            };
            wlogout.enable = true;
            rofi.enable = true;
            hypridle.enable = true;
            hyprsunset.enable = true;
            notch.enable = true;
            launcher.enable = true;
            flameshot.enable = true;
            thunar.enable = true;
            gtk.enable = true;
            media.enable = true;
            networkmanagerapplet.enable = true;
            cursor = {
                enable = true;
            };
        };
        apps = {
            kitty.enable = false;
            phpstorm.enable = false;
            telegram.enable = true;
            slack.enable = true;
            obsidian.enable = true;
            gdrive.enable = false;
            brave.enable = false;
            discord.enable = true;
            hydralauncher.enable = true;
            stremio.enable = true;
            bitwarden.enable = true;
            dbeaver.enable = true;
            whatsapp.enable = true;
            protonvpn.enable = true;
        };
        sdks = {
            rust = {
                enable = true;
                enableNightly = true;
            };
            node.enable = true;
            go.enable = true;
            zig.enable = true;
        };
    };
}
