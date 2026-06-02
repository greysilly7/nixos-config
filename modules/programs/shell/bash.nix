_:
{
  # TODO: Configure bash
  # https://mynixos.com/home-manager/options/programs.bash
  den.aspects.shell._.bash =
    _:
    {
      homeManager =
        { lib, ... }:
        {
          programs.bash = {
            enable = lib.mkDefault true;
            enableCompletion = lib.mkDefault true;
          };
        };
    };
}
