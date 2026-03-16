{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops.secrets.greysilly7_password.neededForUsers = true;

  users.users.greysilly7 = {
    isNormalUser = true;
    homix = true;
    hashedPasswordFile = config.sops.secrets.greysilly7_password.path;
    extraGroups = [
      "wheel"
      "libvertd"
      "networkmanager"
    ];
    shell = pkgs.bash;
    packages = [ 
      pkgs.vscodium
      pkgs.legcord
      pkgs.obsidian
      # pkgs.zed-zed-editor-fhs
      pkgs.gitoxide
      pkgs.libreoffice
      pkgs.vscodium
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
    ];
  };

  programs.fish.enable = true;
  environment.systemPackages = [
    pkgs.fishPlugins.async-prompt
    pkgs.fishPlugins.bass
    pkgs.fishPlugins.hydro
    pkgs.fishPlugins.sponge
    pkgs.fishPlugins.z
  ];
}
