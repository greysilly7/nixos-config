{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}:

{
  options = {
    git = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Git.";
    };
  };

  config = {
    environment.systemPackages = [ pkgs.git ];

    /*
      home-manager.users.greysilly7.programs.git = {
        enable = true;
        userName = "greysilly7";
        userEmail = "greysilly7@gmail.com";

        # signing.key = "";
        # signing.signByDefault = true;

        lfs.enable = true;

        diff-so-fancy.enable = true;

        extraConfig = {
          core.autocrlf = "input";
          init.defaultBranch = "main";
          push.autoSetupRemote = "true";
          pull.rebase = "true";
          rebase.autoStash = "true";
        };
      };
    */
  };
}
