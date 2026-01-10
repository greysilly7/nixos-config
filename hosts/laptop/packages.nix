{ pkgs }:
{
  environment.systemPackages = [
    pkgs.vesktop
    pkgs.obsidian
    pkgs.firefox
    pkgs.zed-zed-editor-fhs
    pkgs.gitoxide
    pkgs.libreoffice-bin
  ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
    };
    adb.enable = true;
  };

  services = {
    udev.packages = [
      pkgs.android-udev-android-udev-rules
    ];
  };
}
