_:
{
  den.aspects.greysilly7 = {
    homeManager =
      { config, ... }:
      {
        sops = {
          secrets = {
            "git/name" = { };
            "git/email" = { };
          };
          templates."git-credentials" = {
            content = ''
              [user]
                  name = "${config.sops.placeholder."git/name"}"
                  email = "${config.sops.placeholder."git/email"}"
            '';
          };
        };
      };
    git =
      { config, ... }:
      {
        includes = [
          { inherit (config.sops.templates."git-credentials") path; }
        ];
      };
  };
}
