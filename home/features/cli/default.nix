{pkgs, ... }: {
    imports = [
        ./lazydocker.nix
        ./zsh.nix
        ./starship.nix
        ./fzf.nix
        ./tmux.nix
        ./fastfetch.nix
        ./lazygit.nix
        ./claude-code.nix
    ];

    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
    };   

    programs.eza = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        extraOptions = [
            "-l" 
            "--icons" 
            "--git" 
            "-a" 
            "--header"
        ];
    };

    programs.bat = {
        enable = true;
    };

    programs.git = {
        enable = true;
        settings = {
            user = {
                name = "David Purtseladze";
                email = "dphurtseladze@gmail.com";
            };
        };
    };

    home.packages = with pkgs; [
        coreutils
        fd
        htop
        httpie
        jq
        procs
        ripgrep
        tldr
        zip
    ];
}