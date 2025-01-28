{pkgs, ...}: {
  security = {
    protectKernelImage = false;
    lockKernelModules = false;
    forcePageTableIsolation = true;
    polkit = {
      enable = true;
      package = pkgs.hyprpolkitagent;
    };
    sudo.package = pkgs.sudo.override {withInsults = true;};

    rtkit.enable = true;
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [pkgs.apparmor-profiles];
    };
  };
  fileSystems = let
    defaults = ["nodev" "nosuid" "noexec"];
  in {
    "/boot".options = defaults;
    "/var/log".options = defaults;
  };
}
