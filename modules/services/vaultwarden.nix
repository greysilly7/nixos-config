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
      DOMAIN = "vaultwarden.greysilly7.xyz";

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
      environmentFile = config.sops.secrets.vaultwarden.path;

      # ADMIN_TOKEN = toString config.sops.secrets."vaultwarden/admin_token";
    };
  };
}
