{ inputs, ... }:
{
  den.aspects.dev._.antigravity-cli = _: {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ inputs.llm-agents.packages.${pkgs.system}.antigravity-cli ];
      };
  };
}
