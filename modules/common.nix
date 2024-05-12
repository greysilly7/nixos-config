{
  config,
  pkgs,
  lib,
  ...
}: {
  sops.secrets.grey_pass.neededForUsers = true;

  users.users = {
    greysilly7 = {
      isNormalUser = true;
      shell = pkgs.bash;
      extraGroups = [
        "wheel"
        "networkmanager"
        "adbusers"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
      ];
      hashedPasswordFile = config.sops.secrets.grey_pass.path;
    };
  };

  programs.adb.enable = true;

  nixpkgs.config.allowUnfree = lib.mkForce true;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Manual optimise storage: nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
}
