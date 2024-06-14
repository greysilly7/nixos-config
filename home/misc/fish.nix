{nixpkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      {
        name = "pure";
        src = nixpkgs.fishPlugins.pure.src;
      }
      {
        name = "sponge";
        src = nixpkgs.fishPlugins.sponge.src;
      }
      {
        name = "async-prompt";
        src = nixpkgs.fishPlugins.async-prompt.src;
      }
    ];
    shellAliases = {
      cat = "bat";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
