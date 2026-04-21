{ lib, den, ... }: {
  options.test-cli = lib.mkOption {
    type = lib.types.anything;
  };
  config.test-cli = den.aspects.cli.includes;
}
