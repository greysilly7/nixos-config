{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = {
    networking.firewall.allowedTCPPorts = [22];
    networking.firewall.allowedUDPPorts = [22];

    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = lib.mkForce true;
        # root user is used for remote deployment, so we need to allow it
        PermitRootLogin = lib.mkForce "prohibit-password";
        PasswordAuthentication = lib.mkForce false; # disable password login
      };
      openFirewall = true;
    };

    # Add terminfo database of all known terminals to the system profile.
    # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/config/terminfo.nix
    environment.enableAllTerminfo = true;
  };
}
