{
  config,
  pkgs,
  sops,
  ...
}: {
  # sops.secrets.grey_pass.neededForUsers = true;

  users = {
    mutableUsers = false;
    users = {
      greysilly7 = {
        isNormalUser = true;
        shell = pkgs.bash;

        extraGroups = ["wheel" "networkmanager" "audio" "video" "storage" "libvirt" "kvm" "docker" "adbusers"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
        ];
        password = "ryker723";
        # hashedPasswordFile = config.sops.secrets.grey_pass.path;
      };
    };
  };
}
