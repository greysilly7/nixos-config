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

    cdnSignaturePath = "/secrets/spacebar/cdnSignature";
    legacyJwtSecretPath = "/secrets/spacebar/legacyJwtSecret";
    # mailjetApiKeyPath = "/run/secrets/spacebar/mailjetApiKey";
    # mailjetApiSecretPath = "/run/secrets/spacebar/mailjetApiSecret";
    smtpPasswordPath = "/secrets/spacebar/smtpPassword";
    # gifApiKeyPath = "/run/secrets/spacebar/gifApiKey";
    # rabbitmqHostPath = "/run/secrets/spacebar/rabbitmqHost";
    # abuseIpDbApiKeyPath = "/run/secrets/spacebar/abuseIpDbApiKey";
    captchaSecretKeyPath = "/secrets/spacebar/captchaSecretKey";
    captchaSiteKeyPath = "/secrets/spacebar/captchaSiteKey";
    # ipdataApiKeyPath = "/run/secrets/spacebar/ipdataApiKey";
    requestSignaturePath = "/secrets/spacebar/requestSignature";

    settings = {
      email = {
        provider = "smtp";
        senderAddress = "no-reply@mail.greysilly7.xyz";
        smtp = {
          host = "smtp.mailgun.org";
          port = 465;
          secure = true;
          username = "no-reply@mail.greysilly7.xyz";
        };
      };
      security = {
        forwardedFor = "X-Forwarded-For";
        trustedProxies = "192.168.0.80";
        cdnSignUrls = true;
        cdnSignatureIncludeIp = true;
        cdnSignatureIncludeUserAgent = true;
        cdnSignatureDuration = "5m";
        captcha = {
          enabled = true;
          service = "recaptcha";
        };
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
          enabled = true;
          guilds = [ "1475999262805341752" ];
        };
        discovery = {
          showAllGuilds = false;
        };
      };
      register = {
        email.required = true;
        dateOfBirth.minimum = 16;
        password.required = true;
        requireCaptcha = true;
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
            limits = {
        guild = {
          maxMembers = 25000000;
          maxEmojis = 2000;
          maxChannelsInCategory = 65535;
          maxChannels = 250;
          maxRoles = 250;
          maxBulkBanUsers = 200;
          maxStickers = 500;
        };
        message = {
          maxCharacters = 1048576;
          maxTTSCharacters = 160;
          maxReactions = 2048;
          maxAttachmentSize = 1073741824;
          maxEmbedDownloadSize = 5242880;
          maxBulkDelete = 1000;
          maxPreloadCount = 100;
        };
        channel = {
          maxPins = 500;
          maxTopic = 1024;
          maxWebhooks = 100;
        };
        rate = {
          ip = {
            window = 5;
            count = 500;
          };
          global = {
            count = 250;
            window = 5;
          };
          error = {
            window = 5;
            count = 10;
          };
          routes = {
            guild = {
              window = 5;
              count = 5;
            };
            webhook = {
              count = 10;
              window = 5;
            };
            channel = {
              count = 10;
              window = 5;
            };
            auth = {
              login = {
                window = 60;
                count = 5;
              };
              register = {
                count = 2;
                window = 43200;
              };
            };
          };
          enabled = false;
        };
        user = {
          maxGuilds = 1000;
          maxUsername = 64;
          maxFriends = 2000;
          maxBio = 500;
        };
        absoluteRate = {
          register = {
            limit = 25;
            window = 3600000;
            enabled = false;
          };
          sendMessage = {
            limit = 120;
            window = 60000;
            enabled = false;
          };
        };
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
