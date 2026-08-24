{
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
    ./kitty.nix
    ./phpstorm.nix
    ./gdrive.nix
    ./brave.nix
    ./misc.nix
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
}
