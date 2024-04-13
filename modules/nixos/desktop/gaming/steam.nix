{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    steam = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Steam.";
    };
  };

  config = lib.mkIf config.options.steam {
    programs.steam.enable = true;

    environment.systemPackages = with pkgs; [ steamPackages.steamcmd ];

    # better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";
  };
}
