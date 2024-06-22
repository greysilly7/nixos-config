{pkgs, ...}: let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/Alpaca-Industries/iremia-comeback/raw/1.0.0/pack.toml";
    packHash = "1edbfcc012b805d60217bac4ed5903cc6854f24bf84d6ef9c1e7a7c38d3855bb";
  };
in {
  services.minecraft-servers.servers.iremia = {
    enable = true;
    autoStart = true;
    package = pkgs.fabricServers.fabric-1_21;

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
      "config" = "${modpack}/config";
    };
  };
}
