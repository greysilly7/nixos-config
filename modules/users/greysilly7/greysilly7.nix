_:
{
  den.aspects.greysilly7 = {
    nixos =
      _:
      {
        sops.secrets = {
          greysilly7_password.neededForUsers = true;
        };
      };
    user =
      { config, ... }:
      {
        hashedPasswordFile = config.sops.secrets.greysilly7_password.path;
        extraGroups = [ "wheel" ];
      };
  };
}
