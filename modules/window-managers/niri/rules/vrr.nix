_:
{
  den.aspects.niri._.rules._.vrr =
    _:
    {
      homeManager =
        { pkgs, lib, ... }:
        lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          programs.niri.settings = {
            window-rules = [
              {
                # VRR allowlist
                matches = [
                  { app-id = "^steam_app.*"; } # Most steam games
                  { app-id = "^RSG-Linux-Shipping$"; } # Everspace native linux version
                ];
                variable-refresh-rate = true;
                open-focused = true;
              }
              {
                # VRR blocklist
                matches = [
                  {
                    app-id = "^steam_app.*";
                    title = "^Unrailed!$";
                  }
                  { app-id = "^steam_app_881100$"; } # Noita
                  { app-id = "^steam_app_323190$"; } # Frostpunk
                  # { app-id = "^steam_app_2246340$"; } # MH:Wilds
                ];
                variable-refresh-rate = false;
              }
            ];
          };
        };
    };
}
