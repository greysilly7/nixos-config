{
  config,
  lib,
  pkgs,
  inputs,
  sops,
  ...
}: {
  config = {
    systemd.services.cloudflare-dyndns = {
      description = "CloudFlare Dynamic DNS Client";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      startAt = "*:0/5";

      environment = {
        CLOUDFLARE_DOMAINS = toString ["greysilly7.xyz"];
      };

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "cloudflare-dyndns";
        Environment = ["CLOUDFLARE_API_TOKEN=${sops.cftoken}"];
        ExecStart = let
          args = ["--cache-file /var/lib/cloudflare-dyndns/ip.cache" "-4" "-6"];
        in "${pkgs.cloudflare-dyndns}/bin/cloudflare-dyndns ${toString args}";
      };
    };
  };
}
