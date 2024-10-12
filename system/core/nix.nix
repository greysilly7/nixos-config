{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alejandra
    deadnix
    git
    nix-output-monitor
    statix
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/greysilly7/git/nixos-config";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Faster rebuilding
  documentation = {
    enable = true;
    dev.enable = false;
    doc.enable = false;
    man.enable = true;
  };

  nix = {
    # GC kills SSDs
    gc.automatic = lib.mkDefault false;

    # Nix but cooler
    package = pkgs.lix;

    # Make builds run with low priority so my system stays responsive
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    # Pin the registry to avoid downloading and evaluating a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    # Free up to 1GiB whenever there is less than 100MiB left
    extraOptions = ''
      experimental-features = nix-command flakes recursive-nix
      keep-outputs = true
      keep-derivations = true
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';

    settings = {
      accept-flake-config = true;
      allowed-users = ["@wheel"];
      auto-optimise-store = true;
      builders-use-substitutes = true; # Use binary cache, it's not Gentoo
      commit-lockfile-summary = "chore: Update flake.lock";
      extra-experimental-features = ["flakes" "nix-command" "recursive-nix" "ca-derivations"];
      flake-registry = "/etc/nix/registry.json";
      keep-derivations = true;
      keep-going = true; # Continue building derivations if one fails
      keep-outputs = true;
      log-lines = 20;
      max-jobs = "auto";
      sandbox = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
        "https://nyx.chaotic.cx"
        "https://mynixconfig.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "mynixconfig.cachix.org-1:vpnituvpFnvJGeGVUOn1EBW5ZxPAu0IVXNP2ySyCgtk="
      ];
      trusted-users = ["@wheel"];
      warn-dirty = false;
    };
  };

  # System state version
  system.stateVersion = "24.05"; # Set the system state version
}
