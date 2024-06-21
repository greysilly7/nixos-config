{pkgs, ...}: let
  modpack = pkgs.fetchPackwizModpack {
    url = "";
    packHash = "";
  };
in {
  services.minecraft-servers.servers.iremia = {
    enable = true;
    package = pkgs.fabricServers.fabric-1_21;
    symlinks = {
      "mods" = "${modpack}/mods";
      "config" = "${modpack}/config";
    };
  };
}
