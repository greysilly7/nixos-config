{
  config,
  pkgs,
  ...
}: {
  # SOPS secrets configuration
  sops.secrets.grey_pass.neededForUsers = true;

  # User configuration
  users = {
    mutableUsers = false;
    users = {
      greysilly7 = {
        extraGroups = [
          "wheel"
          "networkmanager"
          "audio"
          "video"
          "storage"
          "libvirt"
          "kvm"
          "docker"
          "adbusers"
          "input"
        ];
        hashedPasswordFile = config.sops.secrets.grey_pass.path;
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
        ];
        shell = pkgs.bash;
      };
      nixosvmtest = {
        extraGroups = [
          "wheel"
          "networkmanager"
          "audio"
          "video"
          "storage"
          "libvirt"
          "kvm"
          "docker"
          "adbusers"
        ];
        initialPassword = "test";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
        ];
        shell = pkgs.bash;
      };
    };
  };
}
