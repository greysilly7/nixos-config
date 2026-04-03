{
  inputs,
  den,
  ...
}: {
  den.aspects.cli._.eza = den.lib.perUser {
    homeManager = {lib, ...}: {
      # TODO: Configure eza
      programs.eza = {
        enable = lib.mkDefault true;
        enableBashIntegration = lib.mkDefault true;
        enableZshIntegration = lib.mkDefault true;
        icons = lib.mkDefault "always";
        git = lib.mkDefault true;
        extraOptions = lib.mkDefault [
          "--group-directories-first"
          "--header"
        ];
      };
    };
  };
}
