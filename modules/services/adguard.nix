{pkgs, ...}: {
  config = {
    services.adguardhome = {
      enable = true;

      settings = {
        http = {
          address = "0.0.0.0:3000";
        };
        users =
          - {
            name = "admin";
            password = "$2a$12$VCHIjSdvMSa.x1ICJZCPwO5s0y4CbROIx73zE8rY8nU980R2OkDai";
          };
      };

      openFirewall = true;
    };
  };
}
