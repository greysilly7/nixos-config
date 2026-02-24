{ spacebar, ... }:
let
  mkEndpoint = domain: port: ssl: {
    host = domain;
    localPort = port;
    useSsl = ssl;
    publicPort =
      if ssl then
        443
      else if domain == "localhost" then
        port
      else
        80;
  };
in
{
  imports = [ spacebar.nixosModules.default ];
  services.spacebarchat-server = {
    enable = true;
    serverName = "spacebar.greysilly7.xyz";
    apiEndpoint = mkEndpoint "api-spacebar.greysilly7.xyz" 3001 true;
    gatewayEndpoint = mkEndpoint "gateway-spacebar.greysilly7.xyz" 3002 true;
    cdnEndpoint = mkEndpoint "cdn-spacebar.greysilly7.xyz" 3003 true;
    cdnPath = "/storage";
    enableCdnCs = true;

    cdnSignaturePath = "/secrets/spacebar/cdnSignature";
    legacyJwtSecretPath = "/secrets/spacebar/legacyJwtSecret";
    # mailjetApiKeyPath = "/run/secrets/spacebar/mailjetApiKey";
    # mailjetApiSecretPath = "/run/secrets/spacebar/mailjetApiSecret";
    # smtpPasswordPath = "/run/secrets/spacebar/smtpPassword";
    # gifApiKeyPath = "/run/secrets/spacebar/gifApiKey";
    # rabbitmqHostPath = "/run/secrets/spacebar/rabbitmqHost";
    # abuseIpDbApiKeyPath = "/run/secrets/spacebar/abuseIpDbApiKey";
    # captchaSecretKeyPath = "/run/secrets/spacebar/captchaSecretKey";
    # captchaSiteKeyPath = "/run/secrets/spacebar/captchaSiteKey";
    # ipdataApiKeyPath = "/run/secrets/spacebar/ipdataApiKey";
    requestSignaturePath = "/secrets/spacebar/requestSignature";

    settings = {
      security = {
        forwardedFor = "X-Forwarded-For";
        trustedProxies = "192.168.0.80, linklocal";
        cdnSignUrls = true;
        cdnSignatureIncludeIp = true;
        cdnSignatureIncludeUserAgent = true;
        cdnSignatureDuration = "5m";
      };
      general = {
        frontPage = "https://spacebar.greysilly7.xyz";
        instanceDescription = "vroom vroom hheh e";
        instanceId = "1406124638051864608";
        instanceName = "Fastbar";
        publicUrl = "https://spacebar.greysilly7.xyz";
        tosPage = "https://docs.spacebar.chat/contributing/conduct/";
        correspondenceUserID = "1006598230156341276";
        correspondenceEmail = "greysilly7@greysilly7.xyz";
      };
      guild = {
        autoJoin = {
          bots = false;
          canLeave = true;
          enabled = false;
          guilds = [ "1006649183970562092" ];
        };
      };
      user = {
        blockedContains = [
          "discord"
          "clyde"
          "mail.ru"
          "penis"
          "child"
          "admin"
          "owner"
          "moderator"
          "Noruya"
          "𝖞𝖔𝖗𝖚𝖟𝖆"
          "spacebar"
          "1488"
          "hitler"
          "nigger"
          "nitro"
          "monero"
          "gmail.com"
          "outlook.com"
          "steam"
        ];
      };
    };
    extraEnvironment = {
      DATABASE = "postgres://spacebar:spacebar@192.168.0.80:5432/sb";
      #WEBRTC_PORT_RANGE=60000-61000;
      #PUBLIC_IP=216.230.228.60;
      LOG_REQUESTS = "-200,204,304";
      LOG_VALIDATION_ERRORS = true;
      #DB_LOGGING=true;
      #LOG_GATEWAY_TRACES=true;
      #LOG_PROTO_UPDATES=true;
      #LOG_PROTO_FRECENCY_UPDATES=true;
      #LOG_PROTO_SETTINGS_UPDATES=true;
      #WRTC_PUBLIC_IP=webrtc.old.server.spacebar.chat;
      WRTC_PUBLIC_IP = "216.230.228.19";
      WRTC_PORT_MIN = 60000;
      WRTC_PORT_MAX = 65000;
      WRTC_LIBRARY = "@spacebarchat/medooze-webrtc";
      #WRTC_LIBRARY=mediasoup-spacebar-wrtc;
    };
  };
}
