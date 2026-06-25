_: {
  den.aspects.vaultwarden = {
    nixos = {
      services.vaultwarden = {
        enable = true;
        config = {
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          DOMAIN = "https://vaultwarden.greysilly7.xyz";
          SIGNUPS_ALLOWED = true;
        };
      };

      services.caddy.virtualHosts."vaultwarden.greysilly7.xyz".extraConfig = ''
        import security_headers
        reverse_proxy localhost:8222
      '';
    };
  };
}
