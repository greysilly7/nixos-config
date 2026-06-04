{
  den,
  lib,
  ...
}:
{
  den.aspects.office = {
    includes = lib.attrValues den.aspects.office._;
  };
}
