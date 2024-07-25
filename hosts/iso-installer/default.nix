{
  nixpkgs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    mkpasswd
    git
    firefox
  ];
  # Use faster squashfs compression
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
  ];
}
