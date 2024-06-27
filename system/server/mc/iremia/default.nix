{
  pkgs,
  lib,
  ...
}: let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/Alpaca-Industries/iremia-comeback/raw/1.0.0/pack.toml";
    packHash = "sha256-i+W0WA/eH/tNmYzguP2/v/rJb1LUnCV4WmMO9FpjcdI=";
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
      server-port = 43000;
      difficulty = 3;
      gamemode = 1;
      max-players = 5;
      motd = "IREMIA!";
      white-list = false;
      enable-rcon = true;
      "rcon.password" = "password";
    };

    symlinks = {
      "mods" = "${modpack}/mods";
      # "config" = "${modpack}/config";
    };
  };
}
