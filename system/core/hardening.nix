{
  pkgs,
  lib,
  ...
}: {
  # disable coredump that could be exploited later
  # and also slow down the system when something crash
  systemd.coredump.enable = false;

  # enable firejail
  programs.firejail.enable = true;

  # enable fail2ban
  services.fail2ban.enable = true;

  # create system-wide executables firefox and chromium
  # that will wrap the real binaries so everything
  # work out of the box.
  programs.firejail.wrappedBinaries = {
    firefox = {
      executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
      profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
    };
    chromium = {
      executable = "${pkgs.lib.getBin pkgs.chromium}/bin/chromium";
      profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
    };
  };

  boot.kernel.sysctl."kernel.yama.ptrace_scope" = lib.mkForce 2;
  boot.kernel.sysctl."kernel.kptr_restrict" = lib.mkForce 2;
  boot.kernel.sysctl."net.core.bpf_jit_enable" = lib.mkDefault false;
  boot.kernel.sysctl."kernel.unprivileged_bpf_disabled" = lib.mkOverride 500 1;
  boot.kernel.sysctl."net.core.bpf_jit_harden" = lib.mkForce 2;
  boot.kernel.sysctl."kernel.ftrace_enabled" = lib.mkDefault false;
  boot.kernel.sysctl."kernel.randomize_va_space" = lib.mkForce 2;

  security.protectKernelImage = lib.mkDefault true;

  boot.kernel.sysctl."net.ipv4.tcp_syncookies" = lib.mkForce 1;
  boot.kernel.sysctl."net.ipv4.tcp_syn_retries" = lib.mkForce 2;
  boot.kernel.sysctl."net.ipv4.tcp_synack_retries" = lib.mkForce 2;
  boot.kernel.sysctl."net.ipv4.tcp_max_syn_backlog" = lib.mkForce 4096;

  boot.kernel.sysctl."net.ipv4.tcp_rfc1337" = lib.mkForce 1;
  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = lib.mkForce 1;
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = lib.mkForce 1;
}
