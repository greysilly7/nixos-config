{ inputs, ... }:
{
  flake-file.inputs.darwin = {
    url = "github:LnL7/nix-darwin";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake-file.inputs.mac-app-util = {
    url = "github:hraban/mac-app-util";
  };

  den.aspects.darwin-base = {
    darwin =
      { pkgs, ... }:
      {
        imports = [
          inputs.mac-app-util.darwinModules.default
        ];

        system.defaults.trackpad.Clicking = true;
        system.defaults.trackpad.TrackpadThreeFingerDrag = true;
        system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
        system.defaults.NSGlobalDomain._HIHideMenuBar = true;
        system.keyboard.enableKeyMapping = true;
        system.keyboard.remapCapsLockToControl = true;
        programs.zsh.enable = true;
        environment.systemPackages = with inputs.darwin.packages.${pkgs.stdenvNoCC.hostPlatform.system}; [
          darwin-option
          darwin-rebuild
          darwin-version
          darwin-uninstaller
        ];
      };

    provides.to-users = _: {
      homeManager = _: {
        imports = [
          inputs.mac-app-util.homeManagerModules.default
        ];
      };
    };
  };
}
