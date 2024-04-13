{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.desktop.gaming.steam.enable = lib.mkEnableOption "Enable Intel Support";

  config = lib.mkIf config.desktop.gaming.steam.enable {
    programs.steam.enable = true;

    environment.systemPackages = with pkgs; [ steamPackages.steamcmd ];

    # better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";
  };
}
