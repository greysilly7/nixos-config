{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  home = {
    username = "greysilly7";
    homeDirectory = "/home/greysilly7";
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };
}
