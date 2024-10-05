{
  config,
  inputs,
  pkgs,
  ...
}: {
  systemd.services.pocbot = {
    description = "POCBot Service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      EnvironmentFile = config.sops.secrets.pocbot_token.path;
      ExecStart = "${inputs.pocbot}/target/release/pocbot";
      Restart = "always";
      User = "pocbot";
      Group = "pocbot";
    };
  };

  users.groups.pocbot = {};
  users.users.pocbot = {
    isSystemUser = true;
    description = "POCBot User";
    home = "/var/lib/pocbot";
    group = "pocbot";
    createHome = true;
  };
}
