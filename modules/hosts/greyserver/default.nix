{
  den,
  ...
}:
{
  den.aspects.greyserver = {
    includes = [
      den.aspects.system-type._.basic
    ];

    provides.to-users = _: {
      includes = [
        den.aspects.system-type._.basic
      ];
    };

    provides.greysilly7 = _: [
      den.aspects.system-type._.basic
    ];

    nixos = {
      system.stateVersion = "24.05";

      # Example sops configuration
      # sops.defaultSopsFile = self + "/secrets/greysilly7/secrets.yaml";
    };
  };
}
