{ inputs, ... }:
{
  den.aspects.darwin-base = {
    darwin =
      { pkgs, lib, config, ... }:
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
        environment.systemPackages = with inputs.darwin.packages.${pkgs.stdenvNoCC.hostPlatform.system}; [
          darwin-option
          darwin-rebuild
          darwin-version
          darwin-uninstaller
        ];

        system.activationScripts.postActivation.text = lib.mkAfter ''
          HM_APPS="${config.users.users.scottgould.home}/Applications/Home Manager Apps"
          if [ -d "$HM_APPS" ]; then
            /usr/bin/xattr -r -d com.apple.quarantine "$HM_APPS" 2>/dev/null || true
          fi
        '';
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
