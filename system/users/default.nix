{ ... }:
{
  imports = [
    ./greysilly7
  ];
  users = {
    mutableUsers = false;
    users.root = {
      hashedPassword = "$y$j9T$sMqIA3XFlV9qexbX/0qyk/$BtQBmvsoP/ZfPGlk0JiG4YMq7umR1HQE9t.awOVDVh5";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
      ];
    };
  };
}
