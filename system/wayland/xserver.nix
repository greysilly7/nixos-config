{...}: {
  # services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "greysilly7";
  };
  services.libinput = {
      enable = true;
      # mouse = {
      #   accelProfile = "flat";
      # };
    };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };
  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
