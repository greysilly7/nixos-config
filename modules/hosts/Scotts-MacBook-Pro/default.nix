{ den, ... }:
{
  den.aspects.Scotts-MacBook-Pro = {
    includes = [
      den.aspects.darwin-base
    ];
    darwin = {pkgs, ...} =
      {
        security.pam.enableSudoTouchIdAuth = true;
        system.stateVersion = 6;
        system.primaryUser = "scottgould";
      };
  };
}