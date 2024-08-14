{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # inputs.nix-minecraft.nixosModules.minecraft-servers

    ./cloudflared.nix
    ./nginx.nix
    ./vaultwarden.nix
    ./adguard.nix
    ./spacebarserver.nix
    ./postgres.nix

    # Mincraft Servers being hosted on this machine
    # ./mc
  ];
  # nixpkgs.overlays = [inputs.nix-minecraft.overlay];

  environment.systemPackages = with pkgs; [
    tmux
  ];

  # Add terminfo database of all known terminals to the system profile.
  # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/config/terminfo.nix
  environment.enableAllTerminfo = true;
}
