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
    ../common/modules/programs/desktop.nix
    ../common/modules/programs/general.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {inherit inputs outputs;};
    users.nik-a73 = import ../../home/nik-a73/nik-a73.nix;
  };
}
