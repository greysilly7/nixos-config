{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  MHz = x: x * 1000;

  cfg = config.hardware.laptop;
in {
  options = {
    hardware.laptop.enable = mkEnableOption "Enable laptop specific configuration";
  };

  config = mkIf cfg.enable {
    services = {
      thermald.enable = true;
      fprintd.enable = true;
      upower = {
        enable = true;
        percentageLow = 15;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate";
      };
      auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            scaling_min_freq = mkDefault (MHz 1700);
            scaling_max_freq = mkDefault (MHz 2500);
            turbo = "never";
          };
          charger = {
            governor = "performance";
            scaling_min_freq = mkDefault (MHz 2000);
            scaling_max_freq = mkDefault (MHz 4100);
            turbo = "auto";
          };
        };
      };
    };
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
    };
  };
}
