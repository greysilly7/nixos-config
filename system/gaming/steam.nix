{pkgs, ...}: {
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  environment.systemPackages = with pkgs; [steamPackages.steamcmd];

  # better for steam proton games
  systemd.extraConfig = "DefaultLimitNOFILE=524288";
  # systemd.services."user@1000".serviceConfig.LimitNOFILE = "unlimited";
}
