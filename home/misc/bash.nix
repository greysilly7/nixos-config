{nixpkgs, ...}: {
  # Shell settings
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
    };

    initExtra = ''
      if [[ $(${nixpkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${nixpkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
