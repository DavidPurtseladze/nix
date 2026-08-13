{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wlogout;
  icons = ./assets/wlogout;
in {
  options.features.desktop.wlogout.enable = mkEnableOption "wlogout logout screen";

  config = mkIf cfg.enable {
    programs.wlogout = {
      enable = true;

      layout = [
        {
          label = "lock";
          action = "hyprlock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "logout";
          action = "loginctl kill-session $XDG_SESSION_ID";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          # NOTE: hibernate needs swap to actually work, and hardware-configuration.nix
          # currently has swapDevices = [ ]; - this button will fail until swap exists.
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }
      ];

      # TODO: Colors are static (no matugen wired up currently) - picked to match
      style = ''
        * {
          background-image: none;
          font-size: 20px;
          font-family: "FiraCode Nerd Font";
        }

        window {
          background-color: rgba(17, 17, 17, 0.45);
        }

        button {
          border-radius: 20px;
          margin: 10px;
          color: #f8f8f2;
          border-color: #f8f8f2;
          background-color: rgba(0, 0, 0, 0.5);
          outline-style: none;
          border-style: solid;
          border-width: 0px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          box-shadow: none;
          text-shadow: none;
        }

        button:hover,
        button:focus {
          background-color: #9742b5;
          background-size: 30%;
          transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682);
        }

        button span {
          font-size: 1.2em;
        }

        #lock {
          background-image: image(url("${icons}/lock.png"));
        }

        #logout {
          background-image: image(url("${icons}/logout.png"));
        }

        #suspend {
          background-image: image(url("${icons}/sleep.png"));
        }

        #shutdown {
          background-image: image(url("${icons}/power.png"));
        }

        #reboot {
          background-image: image(url("${icons}/restart.png"));
        }

        #hibernate {
          background-image: image(url("${icons}/hibernate.png"));
        }
      '';
    };
  };
}
