_: {
  den.aspects.vaultwarden = {
    nixos = {
      services.vaultwarden = {
        enable = true;
        config = {
          ROCKET_ADDRESS = "100.74.250.64";
          ROCKET_PORT = 8222;
          DOMAIN = "https://vaultwarden.greysilly7.xyz";
          SIGNUPS_ALLOWED = true;
        };
      };
    };
  };
}
