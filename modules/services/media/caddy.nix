_:
{
  den.aspects.media._.caddy = {
    nixos =
      _:
      {
        # Caddy Reverse Proxy
        services.caddy = {
          enable = true;
          virtualHosts = {
            "seerr.greysilly7.xyz".extraConfig = ''
              reverse_proxy localhost:5055
            '';
            "aiostreams.greysilly7.xyz".extraConfig = ''
              reverse_proxy localhost:3000
            '';
            "zipline.greysilly7.xyz".extraConfig = ''
              reverse_proxy localhost:3001
            '';
            "jellyfin.greysilly7.xyz".extraConfig = ''
              reverse_proxy localhost:8096
            '';
            "sonarr.greysilly7.xyz".extraConfig = ''
              reverse_proxy localhost:8989
            '';
            "radarr.greysilly7.xyz".extraConfig = ''
              reverse_proxy localhost:7878
            '';
            "lidarr.greysilly7.xyz".extraConfig = ''
              reverse_proxy localhost:8686
            '';
            "prowlarr.greysilly7.xyz".extraConfig = ''
              reverse_proxy localhost:9696
            '';
          };
        };
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
      };
  };
}
