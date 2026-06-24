_: {
  den.aspects.media._.caddy = {
    nixos = _: {
      # Caddy Reverse Proxy
      services.caddy = {
        enable = true;
        virtualHosts = {
          "seerr.greyserver".extraConfig = ''
            reverse_proxy localhost:5055
          '';
          "aiostreams.greyserver".extraConfig = ''
            reverse_proxy localhost:3000
          '';
          "zipline.greyserver".extraConfig = ''
            reverse_proxy localhost:3001
          '';
          "jellyfin.greyserver".extraConfig = ''
            reverse_proxy localhost:8096
          '';
          "sonarr.greyserver".extraConfig = ''
            reverse_proxy localhost:8989
          '';
          "radarr.greyserver".extraConfig = ''
            reverse_proxy localhost:7878
          '';
          "lidarr.greyserver".extraConfig = ''
            reverse_proxy localhost:8686
          '';
          "prowlarr.greyserver".extraConfig = ''
            reverse_proxy localhost:9696
          '';
          "greyserver".extraConfig = ''
            handle_path /seerr* {
              reverse_proxy localhost:5055
            }
            handle_path /aiostreams* {
              reverse_proxy localhost:3000
            }
            handle_path /zipline* {
              reverse_proxy localhost:3001
            }
            handle_path /jellyfin* {
              reverse_proxy localhost:8096
            }
            handle_path /sonarr* {
              reverse_proxy localhost:8989
            }
            handle_path /radarr* {
              reverse_proxy localhost:7878
            }
            handle_path /lidarr* {
              reverse_proxy localhost:8686
            }
            handle_path /prowlarr* {
              reverse_proxy localhost:9696
            }
            handle {
              redir /jellyfin
            }
          '';
        };
      };
      services.avahi.extraServiceFiles = {
        http = ''
          <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
          <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
          <service-group>
            <name replace-wildcards="yes">%h</name>
            <service>
              <type>_http._tcp</type>
              <port>80</port>
            </service>
            <service>
              <type>_https._tcp</type>
              <port>443</port>
            </service>
          </service-group>
        '';
      };
    };
  };
}
