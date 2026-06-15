{ den, lib, ... }:
{
  den.aspects.media = {
    includes = lib.attrValues den.aspects.media._;
  };
}
