{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users = {
    greysilly7 = {
      isNormalUser = true;
      shell = pkgs.bash;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
      ];
      hashedPassword = "$y$j9T$udZLuDN7IAY6sszOXRezX/$Uex5bkGui/hngWcQE6D1buzSMheTKml4igH73JNzZSA";
    };
  };

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
