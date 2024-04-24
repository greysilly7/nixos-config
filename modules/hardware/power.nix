{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = {
    # Battery Life Tuning
    services.tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        USB_AUTOSUSPEND = "1";
        WIFI_PWR_ON_BAT = "on";
      };
    };

    # Disable power-profiles-daemon as it conflicts with tlp
    services.power-profiles-daemon.enable = false;

    services.thermald.enable = true;
  };
}
