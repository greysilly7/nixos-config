{config, ...}: {
  services.github-nix-ci = {
    tokenFile = config.sops.secrets.github_ci_token.path;
    personalRunners = {
      "greysilly7/nixos-config".num = 10;
    };
  };
}
