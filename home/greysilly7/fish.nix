{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "async-prompt";
        src = pkgs.fishPlugins.async-prompt.src;
      }
    ];
    shellAliases = {
      cd = "z";
      cat = "bat";
    };
  };
}
