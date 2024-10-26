{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      user = {
        email = "greysilly7@gmail.com";
        name = "greysilly7";
        signingKey = "~/.ssh/id_ed25519.pub";
      };
      init = {
        defaultBranch = "main";
      };
      core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      repack.usedeltabaseoffset = "true";
      pull.ff = "only";
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      rerere = {
        autoupdate = true;
        enabled = true;
      };
    };
  };
}
