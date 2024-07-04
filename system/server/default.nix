{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers

    ./cloudflared.nix
    ./nginx.nix
    ./vaultwarden.nix
    ./adguard.nix
    ./sunshine.nix

    # Mincraft Servers being hosted on this machine
    ./mc
  ];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];

  environment.systemPackages = with pkgs; [
    tmux
  ];

  # services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      # root user is used for remote deployment, so we need to allow it\1
      PermitRootLogin = lib.mkForce "prohibit-password";
      PasswordAuthentication = lib.mkForce false; # disable password login
    };
    openFirewall = true;
  };

  # Add terminfo database of all known terminals to the system profile.
  # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/config/terminfo.nix
  environment.enableAllTerminfo = true;
}
