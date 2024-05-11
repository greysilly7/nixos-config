{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  sops.secrets = {
    grey_pass = {};
    cftoken = {};
    "vaultwarden/admin_password" = {};
    "vaultwarden/db_pass" = {};
  };
}
