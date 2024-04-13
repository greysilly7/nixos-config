{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    git = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and configure git.";
    };
  };

  config = {
    programs.git = {
      enable = true;
      userName = "greysilly7";
      userEmail = "greysilly7@gmail.com";

      signing.key = "5C1E38659FCBCA18";
      signing.signByDefault = true;

      lfs.enable = true;

      diff-so-fancy.enable = true;

      extraConfig = {
        core.autocrlf = "input";
        init.defaultBranch = "main";
        push.autoSetupRemote = "true";
        pull.rebase = "true";
        rebase.autoStash = "true";
        # Allow root to use this repo when rebuilding
        safe.directory = "/home/greysilly7/nixos-config";
      };
    };
  };
}
