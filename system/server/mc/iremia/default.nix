{pkgs, ...}: let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/Alpaca-Industries/iremia-comeback/raw/1.0.0/pack.toml";
    packHash = "sha256-i+W0WA/eH/tNmYzguP2/v/rJb1LUnCV4WmMO9FpjcdI=";
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
