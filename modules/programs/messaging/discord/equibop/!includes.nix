{
  den,
  lib,
  ...
}:
{
  den.aspects.messaging._.discord._.equibop = {
    # Bundles all vesktop components when the complete 'vesktop' sub-aspect is used
    includes = lib.attrValues den.aspects.messaging._.discord._.equibop._;
  };
}
