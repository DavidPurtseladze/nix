{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../common
    ./configuration.nix
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
