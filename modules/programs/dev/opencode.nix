{ inputs, ... }:
{
  den.aspects.dev._.opencode = _: {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ inputs.llm-agents.packages.${pkgs.system}.opencode ];
      };
  };
}
