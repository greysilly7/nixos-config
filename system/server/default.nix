{pkgs, ...}: {
  imports = [
    # inputs.nix-minecraft.nixosModules.minecraft-servers

    ./cloudflared.nix
    ./nginx.nix
    ./vaultwarden.nix
    # ./adguard.nix
    ./spacebarchat
    ./postgres.nix
    ./jankclient.nix
    ./pocbot.nix
  ];

  environment.systemPackages = with pkgs; [
    tmux
  ];

  # Add terminfo database of all known terminals to the system profile.
  # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/config/terminfo.nix
  environment.enableAllTerminfo = true;
}
