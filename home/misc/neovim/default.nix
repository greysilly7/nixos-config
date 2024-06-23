{pkgs, ...}: {
  programs = {
    neovim = {
      enable = true;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  home.packages = with pkgs; [
    ripgrep
    gnumake
    gcc
    luaformatter
  ];

  home.file.".config/nvim/init.lua" = {
    source = ./init.lua;
    force = true;
  };

  home.file.".config/nvim/lua" = {
    source = ./lua;
    recursive = true;
    force = true;
  };
}
