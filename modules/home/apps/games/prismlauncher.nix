{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.myModules.prismlauncher.enable = lib.mkEnableOption "Prism Launcher";

  config = lib.mkIf config.myModules.prismlauncher.enable {
    home.packages = [
      (pkgs.prismlauncher.override {
        jdks = with pkgs; [
          jdk8
          jdk17
          jdk21
          jdk25
        ];
      })
    ];
  };
}
