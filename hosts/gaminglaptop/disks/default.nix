{lib, ...}: {
  imports = [
    ./disko.nix
  ];

  staypls = {
    enable = true;
    dirs = lib.concatLists [
      (lib.forEach ["nixos" "NetworkManager" "nix" "ssh" "secureboot"] (x: "/etc/${x}"))
      (lib.forEach ["bluetooth" "cups" "fwupd" "libvirt" "nixos" "pipewire" "sddm" "sops-nix" "tailscale" "upower"] (x: "/var/lib/${x}"))
    ];
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  services.udisks2.enable = true;
}
