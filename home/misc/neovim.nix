{pkgs, ...}: {
  programs = {
    neovim = {
      enable = true;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
  home.file.".config/nvim" = {
    source = ../../nvchad;
    recursive = true;
    force = true;
  };
}
