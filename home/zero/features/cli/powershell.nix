{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "worklink-pwsh" ''
      export LOCAL_CONFIGURATION_PATH="$HOME/Documents/Projects/Worklink/LocalConfiguration"
      export PSModulePath="$HOME/Documents/Projects/Worklink/PowerShell/Modules''${PSModulePath:+:$PSModulePath}"
      exec ${pkgs.powershell}/bin/pwsh "$@"
    '')
  ];
}
