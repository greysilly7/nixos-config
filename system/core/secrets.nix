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
      tailscale_srv_key = {};
      adguardhomewebpass = {};
      imagorenv = {};
    };
  };
}
