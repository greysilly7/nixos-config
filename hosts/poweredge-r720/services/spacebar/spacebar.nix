{ config, ... }:
{
  services.spacebarchat-server = {
    enable = true;
    databaseFile = config.sops.secrets."spacebar/database".path;
    extraEnvironment = {
      STORAGE_LOCATION = "/turtle/spacebar/cdn_storage";
    };
    settings = {
      gateway = {
        endpointPrivate = "ws://127.0.0.1:3001";
        endpointPublic = "wss://gateway-spacebar.greysilly7.xyz";
      };
      cdn = {
        endpointPrivate = "http://127.0.0.1:3001";
        endpointPublic = "https://cdn-spacebar.greysilly7.xyz/";
        imagorServerUrl = "https://spacebar.greysilly7.xyz/imagor";
      };
      api = {
        endpointPublic = "https://api-spacebar.greysilly7.xyz/api/v9";
      };
      general = {
        instanceName = "Fastbar";
        tosPage = "https://spacebar.greysilly7.xyz/tos.html";
        correspondenceEmail = "greysilly7@greysilly7.xyz";
        image = "https://spacebar.greysilly7.xyz/logo.png";
      };

      rabbitmq = {
        host = "amqp://guest:guest@127.0.0.1:5672";
      };
    };
  };

  services.rabbitmq.enable = true;
}
