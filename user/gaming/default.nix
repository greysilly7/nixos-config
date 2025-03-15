{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.lutris
    pkgs.heroic
    # (prismlauncher.override {withWaylandGLFW = true;})
    pkgs.prismlauncher
  ];

  # Gamemode
  programs.gamemode.enable = true;

  # Steam Controller support
  hardware.steam-hardware.enable = true;
  # Xbox controller
  hardware.xpadneo.enable = true;

  programs.steam = {
    enable = true;
    # dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;

    extraCompatPackages = [pkgs.proton-ge-bin];
  };
}
