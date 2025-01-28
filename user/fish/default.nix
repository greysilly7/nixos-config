{
  pkgs,
  lib,
  ...
}: {
  programs = {
    bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    fish = {
      enable = true;
      useBabelfish = true;
      promptInit = "${lib.getExe pkgs.starship} init fish | source";
      vendor.completions = true;
    };
  };

  environment.systemPackages = [
    pkgs.fishPlugins.async-prompt
    pkgs.fishPlugins.sponge
    pkgs.fishPlugins.fzf
    pkgs.fishPlugins.done
    pkgs.fishPlugins.z
  ];
}
