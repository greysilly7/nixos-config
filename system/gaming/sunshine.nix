{...}: {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  services.udev.extraRules = ''
    # Allow users in the input group to access the /dev/input/event* devices
    KERNEL=="event*", GROUP="input", MODE="660"
  '';
}
