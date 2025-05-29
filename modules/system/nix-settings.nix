{
  inputs,
  pkgs,
  ...
}: {
  nix = {
    # I like my SSD
    gc.automatic = false;
    package = pkgs.lix;

    settings = {
      flake-registry = "/etc/nix/registry.json";
      auto-optimise-store = true;
      builders-use-substitutes = true;

      allowed-users = ["@wheel" "@builders"];
      trusted-users = ["@wheel" "@builders"];

      sandbox = true;
      max-jobs = "auto";

      extra-experimental-features = ["flakes" "nix-command" "recursive-nix" "ca-derivations"];

      substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
        "https://nix-community.cachix.org"
        "https://numtide.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
    };
  };
  nixpkgs.overlays = [inputs.fenix.overlays.default];

  # NH my beloved
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/greysilly7/nixos-config";
  };

  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };

  system.switch = {
    enable = false;
    enableNg = true;
  };

  # I want non-nixos to work
  programs.nix-ld = {
    enable = true;
    libraries = [];
  };

  environment.ldso32 = null;
}
