{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.git;
in {
  options.features.cli.git = {
    enable = mkEnableOption "git configuration";

    userName = mkOption {
      type = types.str;
      description = ''
        Git commit author name. No default on purpose - this module is
        shared, so each user config (e.g. home/zero/zero.nix) must set its
        own.
      '';
    };

    userEmail = mkOption {
      type = types.str;
      description = ''
        Git commit author email. No default on purpose - this module is
        shared, so each user config (e.g. home/zero/zero.nix) must set its
        own.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user = {
        name = cfg.userName;
        email = cfg.userEmail;
      };
    };
  };
}
