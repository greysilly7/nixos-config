{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      lfs = {
        enable = true;
        enablePureSSHTransfer = true;
      };
      config = {
        init = {
          defaultBranch = "main";
        };
        core = {
          preloadindex = true;
          whitespace = "trailing-space";
          compression = 9;
        };
        push = {
          default = "current";
          autoSetupRemote = true;
          rebase = true;
        };
      };
    };
  };
  environment.systemPackages = [
    pkgs.wget2
    pkgs.curl
    pkgs.kitty.terminfo
    pkgs.file
    pkgs.unzip
    pkgs.zip
    pkgs.brotli
    pkgs.dnsutils
    pkgs.tmux
    pkgs.nixd
  ];
}
