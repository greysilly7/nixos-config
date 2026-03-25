{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops.secrets.greysilly7_password.neededForUsers = true;

  users.users.greysilly7 = {
    isNormalUser = true;
    homix = true;
    hashedPasswordFile = config.sops.secrets.greysilly7_password.path;
    extraGroups = [
      "wheel"
      "libvertd"
      "networkmanager"
    ];
    shell = pkgs.bash;
    packages = [
      pkgs.vscodium
      pkgs.legcord
      pkgs.obsidian
      pkgs.gitoxide
      pkgs.libreoffice
      pkgs.antigravity
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
    ];
  };

  programs = {
    fish = {
      enable = true;
      generateCompletions = true;
    };
    bash = {
      interactiveShellInit = ''
        if uwsm check may-start && uwsm select; then
	        exec uwsm start default
        fi

        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi      
      '';
    };
  };
  environment.systemPackages = [
    pkgs.fishPlugins.bass
    pkgs.fishPlugins.hydro
    pkgs.fishPlugins.sponge
    pkgs.fishPlugins.z
  ];
}
