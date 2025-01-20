{...}: {
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["greysilly7"];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest
}
