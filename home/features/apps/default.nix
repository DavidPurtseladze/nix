{
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
    ./kitty.nix
    ./phpstorm.nix
    ./misc.nix
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
}
