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
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;

  sops.secrets = {
    grey_pass = {};
    cftoken = {};
    vaultwarden = {};
    cf_acme = {};
  };
}
