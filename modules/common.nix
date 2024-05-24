{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  sops.secrets.grey_pass.neededForUsers = true;
  nixpkgs.config.allowUnfree = lib.mkForce true;

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
  environment.systemPackages = with pkgs; [inputs.alejandra.defaultPackage.${system}];

  # Fix for swaylock
  security.pam.services.swaylock = {};

  programs.adb.enable = true;
  # Manual optimise storage: nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
}
