{
  pkgs,
  lib,
  ...
}: let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/Alpaca-Industries/iremia-comeback/raw/1.0.2/pack.toml";
    packHash = "sha256-/G6+BjhdesnQf/OzY+4qx9NPECvWlkpKe1VgZVZM9Is=";
  };
  mcVersion = modpack.manifest.versions.minecraft;
  fabricVersion = modpack.manifest.versions.fabric;
  serverVersion = lib.replaceStrings ["."] ["_"] "fabric-${mcVersion}";
in {
  services.minecraft-servers.servers.iremia = {
    enable = true;
    autoStart = true;
    package = pkgs.fabricServers.${serverVersion}.override {loaderVersion = fabricVersion;};

    serverProperties = {
      server-port = 18611;
      /*
      difficulty = 3;
      gamemode = 1;
      max-players = 5;
      motd = "IREMIA!";
      white-list = false;
      */
      enable-rcon = true;
      "rcon.password" = "password";
    };

    symlinks = {
      "mods" = "${modpack}/mods";
      # "config" = "${modpack}/config";
    };
  };
}
