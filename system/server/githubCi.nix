{config, ...}: {
  services.github-nix-ci = {
    age.secretsDir = null;
    personalRunners = {
      tokenFile = config.sops.secrets.github_ci_token.path;
      "greysilly7/nixos-config".num = 10;
    };
  };
}
