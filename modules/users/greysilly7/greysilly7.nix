{den, ...}: {
  den.aspects.greysilly7 = {
    nixos = {config, ...}: {
      sops.secrets = {
        greysilly7_password.neededForUsers = true;
      };
    };
    user = {config, ...}: {
      hashedPasswordFile = config.sops.secrets.greysilly7_password.path;
      extraGroups = ["wheel"];
    };
  };
}
