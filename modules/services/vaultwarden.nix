_: {
  den.aspects.vaultwarden = {
    nixos = {
      services.vaultwarden = {
        enable = true;
        config = {
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          DOMAIN = "https://vaultwarden.greysilly7.xyz";
          SIGNUPS_ALLOWED = false;
        };
      };

      services.caddy.virtualHosts."vaultwarden.greysilly7.xyz".extraConfig = ''
        reverse_proxy localhost:8222
      '';
    };
  };
}
