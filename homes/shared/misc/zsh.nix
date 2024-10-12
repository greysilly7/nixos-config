{config, ...}: {
  programs.zsh = {
    enable = true; # Enable Zsh
    enableCompletion = true; # Enable command completion
    autosuggestion.enable = true; # Enable autosuggestions
    syntaxHighlighting.enable = true; # Enable syntax highlighting

    # Define shell aliases
    shellAliases = {
      ll = "ls -l"; # Alias for long listing format
      update = "sudo nixos-rebuild switch"; # Alias to update NixOS
      cat = "bat"; # Alias for bat (a cat clone with syntax highlighting)
    };

    # Configure history settings
    history = {
      size = 10000; # Set history size
      path = "${config.xdg.dataHome}/zsh/history"; # Set history file path
    };

    # Configure Oh My Zsh
    oh-my-zsh = {
      enable = true; # Enable Oh My Zsh
      theme = "lukerandall"; # Set the theme
      plugins = [
        "git" # Git plugin
        "sudo" # Sudo plugin
        "zoxide" # Zoxide plugin
        "bgnotify" # Background notification plugin
        "bun" # Bun plugin
        "node" # Node.js plugin
        "npm" # NPM plugin
      ];
    };
  };

  programs.zoxide = {
    enable = true; # Enable Zoxide
    enableZshIntegration = true; # Enable Zsh integration for Zoxide
  };
}
