{pkgs, ...}: {
  services.xserver = {
    enable = true;
    xkb.layout = "us";

    displayManager.autoLogin = {
      enable = true;
      user = "greysilly7";
    };
    libinput = {
      enable = true;
      # mouse = {
      #   accelProfile = "flat";
      # };
    };
  };
  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
