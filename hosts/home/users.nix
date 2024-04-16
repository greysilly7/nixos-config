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
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      hashedPassword = "$y$j9T$udZLuDN7IAY6sszOXRezX/$Uex5bkGui/hngWcQE6D1buzSMheTKml4igH73JNzZSA";
    };
  };
}
