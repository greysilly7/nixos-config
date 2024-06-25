{pkgs, ...}: {
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = [pkgs.proton-ge-bin];

  environment.systemPackages = with pkgs; [steamPackages.steamcmd];

  # better for steam proton games
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";
}
