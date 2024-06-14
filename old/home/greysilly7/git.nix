{pkgs, ...}: {
  home.file.".ssh/allowed_signers".text = "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com";

  # Git settings
  programs.git = {
    enable = true;
    userName = "Scott Gould";
    userEmail = "greysilly7@gmail.com";

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

      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
