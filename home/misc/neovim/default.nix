{pkgs, ...}: {
  programs = {
    neovim = {
      enable = true;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  home.packsges = with pkgs; [
    ripgrep
    gnumake
    gcc
  ];

  home.file.".config/nvim/init.lua" = {
    source = ./init.lua;
    force = true;
  };

  home.file.".config/nvim/lua" = {
    source = ./lua;
    recusrive = true;
    force = true;
  };
}
