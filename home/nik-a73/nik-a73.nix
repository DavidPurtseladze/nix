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
                # Both panels were running at 60Hz: neither had a monitor
                # rule, so Hyprland took the EDID's preferred mode.
                #
                # Matched by desc: rather than by connector, because the
                # BenQ is expected to move ports - see below.
                monitors = [
                    {
                        # ZOWIE XL, currently on HDMI-A-4. 239.96 is the
                        # ceiling *on that port*, not the panel's: the EDID
                        # reports a 600 MHz max TMDS rate (HDMI 2.0), and
                        # 1080p360 needs more than that, so the 360Hz mode
                        # is not even advertised over HDMI. Move it to a
                        # free DisplayPort (DP-3 or DP-5 on the 4070) with
                        # a DP 1.4 cable and raise this to 1920x1080@360.
                        output = "desc:BNQ ZOWIE XL LCD EBV2R00681SL0";
                        mode = "1920x1080@239.96";
                        position = "0x0";
                    }
                    {
                        # Alienware AW3425DWM on DP-4, at its full 180Hz.
                        output = "desc:Dell Inc. AW3425DWM FSWB444";
                        mode = "3440x1440@179.99";
                        position = "1920x0";
                    }
                ];
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
