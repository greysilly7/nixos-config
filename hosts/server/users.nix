{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # User
  users.users = {
    greysilly7 = {
      isNormalUser = true;
      shell = pkgs.bash;
      extraGroups = [ "wheel" ];
      hashedPassword = "$y$j9T$udZLuDN7IAY6sszOXRezX/$Uex5bkGui/hngWcQE6D1buzSMheTKml4igH73JNzZSA";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
      ];
    };
  };
}
