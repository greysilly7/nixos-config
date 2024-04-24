{pkgs, ...}: {
  # Shell settings
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
    };
  };
}
