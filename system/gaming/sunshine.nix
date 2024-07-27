{...}: {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  services.udev.extraRules = ''
    # Allow users in the input group to access the /dev/input/event* devices
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  '';
}
