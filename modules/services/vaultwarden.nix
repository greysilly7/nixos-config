{
  config,
  lib,
  pkgs,
  inputs,
  sops,
  ...
}: {
  config = {
    services.vaultwarden.enable = true;
    services.vaultwarden.config = {
      DOMAIN = "vaultwarden.greysilly7.net";

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";

      # ADMIN_TOKEN = toString config.sops.secrets."vaultwarden/admin_token";
    };
  };
}
