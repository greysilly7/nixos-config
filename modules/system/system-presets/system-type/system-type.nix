# Preset system types.
# These should be imported by BOTH hosts and users wanting to use them.
{ den, ... }:
{
  den.aspects.system-type = {
    _.basic = {
      includes = with den.aspects; [
        # ---Core Config--- #
        nix-config
        hardware._.firmware

        # ---Basic Tools--- #
        # coolercontrol
        cli
        shell
        git
      ];
    };

    # Make sure to pick a `desktop-type` if you pick a desktop system preset
    _.desktop = {
      includes = [
        den.aspects.system-type._.basic # Inherit `basic` system-type
        # ---Core Aspects--- #
        # display-manager
        den.aspects.audio
        den.aspects.fonts
        # Security
        den.aspects.keyring
        den.aspects.polkit

        # ---Basic Desktop Applications--- #
        den.aspects.terminal
        den.aspects.files
        den.aspects.browser
        den.aspects.misc
        den.aspects.antigravity
      ];

      # Desktop system variant that incorporates extras for gaming systems
      _.gaming = {
        includes = [
          den.aspects.system-type._.desktop # Inherit `desktop` system-type
          # ---Core Aspects--- #
          den.aspects.hardware._.graphics
          den.aspects.ananicy # Auto-nice daemon

          # ---Gaming Related Applications--- #
          den.aspects.steam
          # heroic
          # umu-launcher
          den.aspects.mangohud
          den.aspects.messaging._.discord
        ];
      };
    };
  };
}
