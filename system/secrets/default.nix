{ config, ... }:
{
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
  # This is the actual specification of the secrets.
  sops.secrets."greysilly7/password" = { };
  sops.secrets."spacebar/database" = { };
  sops.secrets."spacebar/imagorenv" = { };
}
