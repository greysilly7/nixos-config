{ den, ... }:
{
  den.aspects.scottgould = {
    includes = [
      den._.primary-user
      den.aspects.secrets._.secretsHome
    ];
    darwin = _: {

    };
    homeManager = _: {
      home.stateVersion = "25.05";
    };
  };
}
