{pkgs, ...}: {
  # Git settings
  programs.git = {
    enable = true;
    userName = "Scott Gould";
    userEmail = "greysilly7@gmail.com";

    signing.key = "6E848CFF095BC47D57E6C3EF5C1E38659FCBCA18";
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
}
