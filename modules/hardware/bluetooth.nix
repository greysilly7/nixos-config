{...}: {
  config = {
    hardware.bluetooth.enable = true;
    # enable blueman
    services.blueman.enable = true;
  };
}
