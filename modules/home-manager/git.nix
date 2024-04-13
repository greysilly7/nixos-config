{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.git.enable = lib.mkEnableOption "Enable git";

  config = mkIf config.git.enable {
    programs.git = lib.mkIf config.git.enable {
      enable = true;
      userName = "Scott Gould";
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
