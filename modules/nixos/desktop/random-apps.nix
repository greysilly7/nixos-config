{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.module.desktop.random-apps.enable = lib.mkEnableOption "Enable Random Packages";

  config = lib.mkIf config.module.desktop.random-apps.enable {
    environment.systemPackages = with pkgs; [
      wget
      curl

      unzip
      zip
      p7zip

      nixfmt-rfc-style

      vesktop
      vscode
      firefox
    ];
  };
}
