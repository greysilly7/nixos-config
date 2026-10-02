{ lib, ... }:
{
  services.caddy = {
    enable = true;

    # You can remove lib.mkAfter entirely if this is the only Nix file configuring Caddy's globalConfig.
    globalConfig = lib.mkAfter ''
      admin 127.0.0.1:2019 {
        origins localhost:2019 127.0.0.1:2019 ultra-channel-7747.taile55d22.ts.net:8443
      }
    '';

    virtualHosts = {
      # Preserve the old hostname without the retired proxy dependency.
      "harbor.greysilly7.xyz".extraConfig = "redir https://ashore.dev{uri}";
      "ashore.dev".extraConfig = "reverse_proxy 100.75.171.127:3000";

      "vaultwarden.greysilly7.xyz".extraConfig = "reverse_proxy greyserver:8222";
      "aiostreams.greysilly7.xyz".extraConfig = "reverse_proxy greyserver:3000";
      "gateway-spacebar.greysilly7.xyz".extraConfig = "reverse_proxy greyserver:3002";
      "api-spacebar.greysilly7.xyz".extraConfig = "reverse_proxy greyserver:3001";
      "cdn-spacebar.greysilly7.xyz".extraConfig = "reverse_proxy greyserver:3003";
      "imagor-spacebar.greysilly7.xyz".extraConfig = "reverse_proxy greyserver:8089";
      "voice-spacebar.greysilly7.xyz".extraConfig = "reverse_proxy greyserver:3005";
      "prowlarr.greysilly7.xyz".extraConfig = "reverse_proxy greyserver:9696";
      "jellyfin.greysilly7.xyz".extraConfig = "reverse_proxy greyserver:8096";
      "silo.greysilly7.xyz".extraConfig = "reverse_proxy greyserver:8280";
    };
  };
}
