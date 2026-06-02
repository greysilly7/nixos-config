{ den, lib, ... }:
{
  den.aspects.editors = {
    # All sub-aspects are included when the generic 'editors' aspect is used
    includes = lib.attrValues den.aspects.editors._;
  };
}
