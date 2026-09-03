{ inputs, ... }:
{
  flake-file.inputs.llm-agents.url = "github:numtide/llm-agents.nix";

  den.aspects.dev._.opencode = _: {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ inputs.llm-agents.packages.${pkgs.system}.opencode ];
      };
  };
}
