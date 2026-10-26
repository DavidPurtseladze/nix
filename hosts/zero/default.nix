{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../common
    ./configuration.nix
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
