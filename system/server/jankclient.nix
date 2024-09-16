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
    sha256 = "sha256-ovXgwlmUeHhjVLHel90qf/GYNIBW2kVqdQ77b/BOQHo="; # Replace with the actual sha256
  };
  writableDir = "/var/lib/jankclient";
in {
  systemd.services.jankClient = {
    description = "Jank Client Service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStartPre = ''
        ${pkgs.coreutils}/bin/mkdir -p ${writableDir}
        ${pkgs.coreutils}/bin/cp -r ${jankClientSrc}/* ${writableDir}
        ${pkgs.coreutils}/bin/chown -R jankclient:jankclient ${writableDir}
        ${pkgs.coreutils}/bin/chmod -R 755 ${writableDir}
      '';
      ExecStart = "${pkgs.bun}/bin/bun ${writableDir}/index.js";
      WorkingDirectory = "${writableDir}";
      Restart = "always";
      User = "jankclient";
      Group = "jankclient";
    };
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

  environment.systemPackages = with pkgs; [bun];
}
