{ inputs, ... }: {

  flake-file.inputs.spacebar = {
    url = "github:spacebarchat/server";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.spacebar = {
    nixos =
      { config, ... }:
      let
        sb = import "${inputs.spacebar}/nix/lib/mkEndpoint.nix";
      in
      {
        imports = [ inputs.spacebar.nixosModules.default ];

        sops.secrets = {
          "spacebar/cdnSignature" = {
            owner = "spacebarchat";
          };
          "spacebar/legacyJwtSecret" = {
            owner = "spacebarchat";
          };
          # "spacebar/mailjetApiKey" = { owner = "spacebarchat"; };
          # "spacebar/mailjetApiSecret" = { owner = "spacebarchat"; };
          # "spacebar/smtpPassword" = { owner = "spacebarchat"; };
          "spacebar/gifApiKey" = {
            owner = "spacebarchat";
          };
          # "spacebar/rabbitmqHost" = { owner = "spacebarchat"; };
          "spacebar/abuseIpDbApiKey" = {
            owner = "spacebarchat";
          };
          "spacebar/captchaSecretKey" = {
            owner = "spacebarchat";
          };
          "spacebar/captchaSiteKey" = {
            owner = "spacebarchat";
          };
          "spacebar/requestSignature" = {
            owner = "spacebarchat";
          };
          "spacebar/database" = { };
          "spacebar/imagorenv" = { };
        };

        services.spacebarchat-server = {
          enable = true;
          serverName = "spacebar.greysilly7.xyz";

          apiEndpoint = sb.mkEndpoint "spacebar.greysilly7.xyz" 3001 true;
          gatewayEndpoint = sb.mkEndpoint "gateway-spacebar.greysilly7.xyz" 3002 true;
          cdnEndpoint = sb.mkEndpoint "cdn-spacebar.greysilly7.xyz" 3003 true;
          # adminApiEndpoint = sb.mkEndpoint "spacebar-admin.greysilly7.xyz" 3004 true;
          webrtcEndpoint = sb.mkEndpoint "voice-spacebar.greysilly7.xyz" 3005 true;

          cdnPath = "/mnt/pool/storage/spacebar_cdn";

          cdnSignaturePath = config.sops.secrets."spacebar/cdnSignature".path;
          legacyJwtSecretPath = config.sops.secrets."spacebar/legacyJwtSecret".path;
          # mailjetApiKeyPath = config.sops.secrets."spacebar/mailjetApiKey".path;
          # mailjetApiSecretPath = config.sops.secrets."spacebar/mailjetApiSecret".path;
          # smtpPasswordPath = config.sops.secrets."spacebar/smtpPassword".path;
          gifApiKeyPath = config.sops.secrets."spacebar/gifApiKey".path;
          # rabbitmqHostPath = config.sops.secrets."spacebar/rabbitmqHost".path;
          abuseIpDbApiKeyPath = config.sops.secrets."spacebar/abuseIpDbApiKey".path;
          captchaSecretKeyPath = config.sops.secrets."spacebar/captchaSecretKey".path;
          captchaSiteKeyPath = config.sops.secrets."spacebar/captchaSiteKey".path;
          requestSignaturePath = config.sops.secrets."spacebar/requestSignature".path;

          pion-sfu = {
            enable = true;
            publicIp = "voice-spacebar.greysilly7.xyz";
          };

          settings = {
            security = {
              forwardedFor = "X-Forwarded-For";
              trustedProxies = "127.0.0.1, linklocal";
              cdnSignUrls = true;
              cdnSignatureIncludeIp = true;
              cdnSignatureIncludeUserAgent = false;
              cdnSignatureDuration = "15m";
            };
            general = {
              frontPage = "https://spacebar.greysilly7.xyz";
              instanceDescription = "Meow";
              instanceId = "1007558287590649856";
              instanceName = "Fastbar";
              publicUrl = "https://spacebar.greysilly7.xyz";
              tosPage = "https://docs.spacebar.chat/contributing/conduct/";
              correspondenceUserID = "";
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
            register = {
              blockIpDataCoThreatTypes = [ ];
              #checkIp = false;
              enableAbuseIpDb = true;
              enableIpData = false; # 1500req/d, needed by gateway
            };
            embeds = {
              youtube = {
                userAgent = "Mozilla/5.0 (compatible; Discordbot/2.0; +https://discordapp.com)";
              };
            };
          };
        };

        services.caddy = {
          enable = true;
          virtualHosts = {
            "spacebar.greysilly7.xyz".extraConfig = ''
              import security_headers
              reverse_proxy localhost:3001
            '';
            "gateway-spacebar.greysilly7.xyz".extraConfig = ''
              import security_headers
              reverse_proxy localhost:3002
            '';
            "cdn-spacebar.greysilly7.xyz".extraConfig = ''
              import security_headers
              reverse_proxy localhost:3003
            '';
            "voice-spacebar.greysilly7.xyz".extraConfig = ''
              import security_headers
              reverse_proxy localhost:3005
            '';
            "imagor-spacebar.greysilly7.xyz".extraConfig = ''
              import security_headers
              reverse_proxy localhost:8089
            '';
          };
        };

        systemd.tmpfiles.rules = [
          "d /var/lib/spacebar/db 0700 root root -"
        ];

        virtualisation.oci-containers.containers."spacebar-db" = {
          image = "postgres:17-alpine";
          extraOptions = [ "--network=host" ];
          environment = {
            POSTGRES_USER = "spacebar";
            POSTGRES_PASSWORD = "spacebar";
            POSTGRES_DB = "sb";
            PGPORT = "5431";
          };
          volumes = [
            "/var/lib/spacebar/db:/var/lib/postgresql/data"
          ];
        };

        virtualisation.oci-containers.containers."spacebar-imagor" = {
          image = "shumc/imagor:latest";
          extraOptions = [ "--network=host" ];
          environment = {
            PORT = "8089";
            IMAGOR_UNSAFE = "0";
          };
          environmentFiles = [ config.sops.secrets."spacebar/imagorenv".path ];
        };

        systemd.services.spacebar-api.serviceConfig.EnvironmentFile =
          config.sops.secrets."spacebar/database".path;
        systemd.services.spacebar-cdn.serviceConfig.EnvironmentFile =
          config.sops.secrets."spacebar/database".path;
        systemd.services.spacebar-gateway.serviceConfig.EnvironmentFile =
          config.sops.secrets."spacebar/database".path;
        systemd.services.spacebar-webrtc.serviceConfig.EnvironmentFile =
          config.sops.secrets."spacebar/database".path;
      };
  };
}
