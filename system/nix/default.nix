{
  pkgs,
  lib,
  ...
}: {
  nix = {
    gc.automatic = false;
    package = pkgs.lix;

    # Make builds run with low priority so my system stays responsive
    daemonCPUSchedPolicy = lib.mkDefault "batch";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = lib.mkDefault 7;

    settings = {
      flake-registry = "/etc/nix/registry.json";
      auto-optimise-store = true;
      # use binary cache, its not gentoo
      builders-use-substitutes = true;
      # allow sudo users to mark the following values as trusted
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
      commit-lockfile-summary = "chore: Update flake.lock";
      accept-flake-config = true;
      keep-derivations = true;
      keep-outputs = true;
      warn-dirty = false;

      sandbox = true;
      max-jobs = "auto";
      # continue building derivations if one fails
      keep-going = true;
      log-lines = 20;
      extra-experimental-features = ["flakes" "nix-command" "recursive-nix" "ca-derivations"];

      # use binary cache, its not gentoo
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://cosmic.cachix.org"
        "https://cache.garnix.io"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/greysilly7/nixos-config";
  };

  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };

  # this makes rebuilds little faster
  system.switch = {
    enable = false;
    enableNg = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "dotnet-runtime-6.0.36"
      ];
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      xorg.libX11
      xorg.libXcursor
      xorg.libxcb
      xorg.libXi
      libxkbcommon
      libGL
      wayland
    ];
  };

  environment.ldso32 = null;
}
