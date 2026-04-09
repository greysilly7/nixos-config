_:
{
  den.aspects.scottgould = {
    darwin = _:
    {

    };
    user =
      { config, ... }:
      {
        hashedPasswordFile = config.sops.secrets.greysilly7_password.path;
        extraGroups = [ "wheel" ];
      };
  };
}
