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
    sha256 = "sha256-WjigAqlqdY4uUIjvHEiVYD+uk/b/IphaqL0Ua+8Gcmw="; # Replace with the actual sha256
  };
  writableDir = "/var/lib/jankclient";
in {
  systemd.services.jankClient = {
    description = "Jank Client Service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    preStart = ''
      ${pkgs.coreutils}/bin/mkdir -p ${writableDir}
      ${pkgs.coreutils}/bin/cp -a -r ${jankClientSrc}/* ${writableDir}
      ${pkgs.coreutils}/bin/chown -R jankclient:jankclient ${writableDir}
      ${pkgs.coreutils}/bin/chmod -R 755 ${writableDir}
      ${pkgs.bun}/bin/bun install
      ${pkgs.bun}/bin/bun run gulp --swc
    '';
    script = "${pkgs.bun}/bin/bun ${writableDir}/dist/index.js";

    serviceConfig = {
      WorkingDirectory = "${writableDir}";
      Restart = "always";
      User = "jankclient";
      Group = "jankclient";
      Environment = [
        "NODE_ENV=production"
      ];
    };

    path = with pkgs; [coreutils bun nodejs_latest];
  };

  users.users.jankclient = {
    isSystemUser = true;
    group = "jankclient";
    home = writableDir;
  };
  users.groups.jankclient = {};

  systemd.tmpfiles.rules = [
    "d ${writableDir} 0755 jankclient jankclient -"
  ];

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
}
