{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    ./gaming
    ./git
    ./gtk
    ./kitty
    ./spicetify
    ./fish
  ];
  sops.secrets.grey_pass.neededForUsers = true;

  users.users.greysilly7 = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "systemd-journal"
      "audio"
      "video"
      "input"
      "lp"
      "networkmanager"
      "power"
      "nix"
      "adbusers"
      "libvirtd"
      "wireshark"
      "kvm"
      "adbusers"
    ];
    homix = true;
    shell = pkgs.bash;
    hashedPasswordFile = config.sops.secrets.grey_pass.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
    ];

    packages = builtins.attrValues {
      inherit
        (pkgs)
        kitty
        gimp
        cpufetch
        microfetch
        vscode
        libreoffice
        dbeaver-bin
        devenv
        legcord
        fastfetch
        gitoxide
        # zed-editor
        mangohud
        nexusmods-app
        obsidian
        ;
    } ++ [
      pkgs.jetbrains.rust-rover
      pkgs.jetbrains.idea-community-bin
      inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
    ];
  };

  programs = {
    direnv = {
      enable = true;
      enableFishIntegration = true;
    };
    adb.enable = true;
  };
  services = {
    flatpak.enable = true;
    udev.packages = [
      pkgs.android-udev-rules
    ];
  };

  homix = {
    ".config/uwsm/env-hyprland".text = ''
      export NIXOS_OZONE_WL="1"
      export __GL_GSYNC_ALLOWED="0"
      export __GL_VRR_ALLOWED="0"
      export _JAVA_AWT_WM_NONEREPARENTING="1"
      # export SSH_AUTH_SOCK="/run/user/1000/keyring/ssh"
      export DISABLE_QT5_COMPAT="0"
      export GDK_BACKEND="wayland"
      export ANKI_WAYLAND="1"
      export DIRENV_LOG_FORMAT=""
      export WLR_DRM_NO_ATOMIC="1"
      export QT_AUTO_SCREEN_SCALE_FACTOR="1"
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export QT_QPA_PLATFORM="xcb"
      export QT_QPA_PLATFORMTHEME="qt5ct"
      export QT_STYLE_OVERRIDE="kvantum"
      export MOZ_ENABLE_WAYLAND="1"
      export WLR_BACKEND="vulkan"
      export WLR_RENDERER="vulkan"
      export WLR_NO_HARDWARE_CURSORS="1"
      export AQ_DRM_DEVICES="/dev/dri/card1:/dev/dri/card0"
      export XDG_SESSION_TYPE="wayland"
      export SDL_VIDEODRIVER="wayland"
      export CLUTTER_BACKEND="wayland"
      export XCURSOR_THEME="default" # Use the default Hyprland cursor theme
      export XCURSOR_SIZE="24" # Set the cursor size
    '';
  };
}
