{config, ...}: {
  services.vaultwarden = {
    enable = true;

    environmentFile = config.sops.secrets.vaultwarden.path;
    # dbBackend = "postgresql";

    config = {
      DOMAIN = "https://vaultwarden.greysilly7.xyz";

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";

      # DATABASE_URL = "postgresql://vaultwarden@127.0.0.1:5432/vaultwarden";
    };
  };
}
