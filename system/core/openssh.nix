{lib, ...}: {
  config = {
    services.openssh = {
      enable = true;
      settings = {
        # root user is used for remote deployment, so we need to allow it
        PermitRootLogin = lib.mkForce "prohibit-password";
        PasswordAuthentication = lib.mkForce false; # disable password login
      };
      openFirewall = true;
      hostKeys = [
        {
          bits = 4096;
          path = "/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    # Add terminfo database of all known terminals to the system profile.
    # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/config/terminfo.nix
    environment.enableAllTerminfo = true;
  };
}
