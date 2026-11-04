{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../common
    ./configuration.nix
    ../common/modules/system/audio.nix
    ../common/modules/system/bluetooth.nix
    ../common/modules/system/boot.nix
    ../common/modules/system/locale.nix
    ../common/modules/system/networking.nix
    ../common/modules/system/power.nix
    ../common/modules/programs/desktop.nix
    ../common/modules/programs/general.nix
    ../common/modules/programs/qylock.nix
    ../common/modules/system/vpn-work.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.qylock.nixosModules.default
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {inherit inputs outputs;};
    users.zero = import ../../home/zero/zero.nix;
  };
}
