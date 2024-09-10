{...}: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age = {
      generateKey = true;
    };
    secrets = {
      grey_pass = {};
      cftoken = {};
      vaultwarden = {};
      cf_acme = {};
      ts_srv_key = {};
      ts_laptop_key = {};
      adguardhomewebpass = {};
      imagorenv = {};
      github_ci_token = {};
    };
  };
}
