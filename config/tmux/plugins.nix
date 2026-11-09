{
    config,
    lib,
    pkgs,
    ...
}:
with lib;
let
    cfg = config.features.cli.tmux;

    tmux-flash = pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "tmux-flash";
        rtpFilePath = "flash.tmux";
        version = "unstable-2026-09-24";
        src = pkgs.fetchFromGitHub {
            owner = "AndreVicencio";
            repo = "tmux-flash";
            rev = "fca00f887cd84a3386315e23c9d06d627cda9cd3";
            hash = "sha256-lNi3JBzkvvV+SvF9uO4zqzyzayZGmOhgZx20HGoYdpc=";
        };

        postInstall = ''
            substituteInPlace $target/flash.sh \
                --replace-fail "/usr/bin/env python3" "${pkgs.python3}/bin/python3"
        '';
    };

    plugins = [
        { plugin = pkgs.tmuxPlugins.resurrect; }
        {
            plugin = pkgs.tmuxPlugins.continuum;
            extraConfig = ''
                set -g @continuum-restore 'on'
                set -g @continuum-save-interval '15'
            '';
        }
        { plugin = pkgs.tmuxPlugins.yank; }
        {
            plugin = tmux-flash;
            extraConfig = ''
                set -g @flash-key "s"
            '';
        }
    ];

    pluginsConf = concatMapStringsSep "\n" (p:
        optionalString (p ? extraConfig) p.extraConfig
        + "run-shell ${p.plugin.rtp}\n"
    ) plugins;
in {
    config = mkIf cfg.enable {
        home.file.".local/state/tmux/plugins.conf".text = pluginsConf;
    };
}
