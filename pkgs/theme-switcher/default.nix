{
  lib,
  buildGoModule,
  matugen,
}:
buildGoModule {
  pname = "theme-switcher";
  version = "0.1.0";

  src = ./.;
  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.matugenBin=${lib.getExe matugen}"
  ];

  meta.mainProgram = "theme";
}
