{...}: {
  sops = {
    # Path to the default SOPS file
    defaultSopsFile = ../../secrets/secrets.yaml;

    age = {
      generateKey = true; # Generate a new key if not present
    };

    secrets = {
      # List of secrets managed by SOPS
      adguardhomewebpass = {};
      cf_acme = {};
      cftoken = {};
      github_ci_token = {};
      grey_pass = {};
      imagorenv = {};
      pocbot_token = {};
      ts_laptop_key = {};
      ts_srv_key = {};
      vaultwarden = {};
    };
  };
}
