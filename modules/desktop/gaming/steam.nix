{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    programs.steam.enable = true;

    environment.systemPackages = with pkgs; [steamPackages.steamcmd];

    # better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";
  };
}
