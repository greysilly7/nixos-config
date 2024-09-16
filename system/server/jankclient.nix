{
  lib,
  config,
  pkgs,
  ...
}: let
  jankClientSrc = pkgs.fetchFromGitHub {
    owner = "MathMan05";
    repo = "JankClient";
    rev = "main"; # You can specify a specific commit or branch
    sha256 = "sha256-DV89mfipDe4gZVa+M4Dbl2c4FhSI0ChTZsc+VewDRxI="; # Replace with the actual sha256
  };
in {
  systemd.services.jankClient = {
    description = "Jank Client Service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = "${pkgs.bun}/bin/bun index.js";
      WorkingDirectory = "${jankClientSrc}";
      Restart = "always";
      User = "jankclient";
      Group = "jankclient";
    };
  };

  users.users.jankclient = {
    isSystemUser = true;
    group = "jankclient";
    home = "/var/lib/jankclient";
  };
  users.groups.jankclient = {};

  services.nginx.virtualHosts = {
    "jankclient.greysilly7.xyz" = {
      forceSSL = true;
      enableACME = true;
      http2 = true;
      http3 = true;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8080";
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [bun];
}
