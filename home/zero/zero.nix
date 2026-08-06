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
        };
        desktop = {
            wayland.enable = true;
            hyprland.enable = true;
            fonts.enable = true;
        };
    };
}
