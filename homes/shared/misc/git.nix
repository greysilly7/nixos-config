{...}: {
  # Configure the allowed signers file for SSH
  home.file.".ssh/allowed_signers".text = "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com";

  programs.git = {
    enable = true; # Enable Git
    userName = "Scott Gould"; # Set Git user name
    userEmail = "greysilly7@gmail.com"; # Set Git user email

    lfs.enable = true; # Enable Git LFS (Large File Storage)

    diff-so-fancy.enable = true; # Enable diff-so-fancy for better diffs

    extraConfig = {
      core.autocrlf = "input"; # Handle line endings automatically
      init.defaultBranch = "main"; # Set default branch name to "main"
      push.autoSetupRemote = "true"; # Automatically set up remote tracking branches
      pull.rebase = "true"; # Use rebase when pulling
      rebase.autoStash = "true"; # Automatically stash changes before rebasing

      # Allow root to use this repo when rebuilding
      safe.directory = "/home/greysilly7/nixos-config";

      commit.gpgsign = true; # Sign commits with GPG
      gpg.format = "ssh"; # Use SSH format for GPG
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers"; # Path to allowed signers file
      user.signingkey = "~/.ssh/id_ed25519.pub"; # Path to SSH public key for signing
    };
  };
}
