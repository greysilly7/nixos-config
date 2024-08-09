{...}: {
  imports = [
    ./system.nix
    # ./schizo.nix
    ./networking.nix
    ./secrets.nix
    ./nix.nix
    ./users.nix
    ./openssh.nix
    ./hardening.nix
  ];
}
