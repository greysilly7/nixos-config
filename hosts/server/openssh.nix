{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  services.openssh = {
    enable = true;

    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  # Allow 22 in firewall
  networking.firewall.allowedTCPPorts = [ 22 ];
}
