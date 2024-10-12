{pkgs, ...}: {
  # Shell settings
  programs.bash = {
    enable = true; # Enable Bash

    initExtra = ''
      # Check if the parent process is not Zsh and if BASH_EXECUTION_STRING is empty
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "zsh" && -z ''${BASH_EXECUTION_STRING} ]]; then
        # Check if the shell is a login shell
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        # Switch to Zsh
        exec ${pkgs.zsh}/bin/zsh $LOGIN_OPTION
      fi
    '';
  };
}
