_: {
  den.aspects.media._.caddy = {
    nixos = _: {
      # Caddy Reverse Proxy
      services.caddy = {
        enable = true;
        extraConfig = ''
          (security_headers) {
            header {
              X-Frame-Options "SAMEORIGIN"
              X-Content-Type-Options "nosniff"
              X-XSS-Protection "1; mode=block"
              Referrer-Policy "strict-origin-when-cross-origin"
              Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
            }
          }
        '';
        virtualHosts = {
          "aiostreams.greysilly7.xyz".extraConfig = ''
            import security_headers
            reverse_proxy localhost:3000
          '';
          "zipline.greysilly7.xyz".extraConfig = ''
            import security_headers
            reverse_proxy localhost:3001
          '';
          "jellyfin.greysilly7.xyz".extraConfig = ''
            import security_headers
            reverse_proxy localhost:8096
          '';
          "prowlarr.greysilly7.xyz".extraConfig = ''
            import security_headers
            reverse_proxy localhost:9696
          '';
          "seerr.greysilly7.xyz".extraConfig = ''
            import security_headers
            reverse_proxy localhost:5055
          '';
          "rsdebrid.com".extraConfig = ''
            import security_headers
            reverse_proxy localhost:29600
          '';
        };
      };
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
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
