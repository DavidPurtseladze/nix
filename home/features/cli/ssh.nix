{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.ssh;
in {
  options.features.cli.ssh = {
    enable = mkEnableOption "SSH client configuration";

    onePasswordAgent.enable =
      mkEnableOption "1Password SSH agent as the source of SSH keys";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;

      # Don't emit home-manager's opinionated Host * block; everything this
      # module cares about is set explicitly below.
      enableDefaultConfig = false;

      # `settings` is keyed by host pattern and takes OpenSSH's own directive
      # names. (The older `matchBlocks."*".identityAgent` spelling still works
      # but is deprecated and warns on every rebuild.)
      settings."*" = mkIf cfg.onePasswordAgent.enable {
        # Keys live in the 1Password vault, not in ~/.ssh. 1Password exposes
        # them over its own agent socket, so ssh asks that agent instead of
        # reading a private key file - authenticating pops a 1Password unlock
        # prompt and the private key never touches disk.
        #
        # The socket only exists once "Use the SSH agent" is turned on under
        # Settings -> Developer in the 1Password desktop app. Until then, ssh
        # has no keys to offer.
        IdentityAgent = "~/.1password/agent.sock";
      };
    };
  };
}
