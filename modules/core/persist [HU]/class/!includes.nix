{ den, ... }:
{
  den.aspects.persist._.class = {
    # Bundles all class components when the complete 'class' sub-aspect is used
    includes = [
      den.aspects.persist._.class._.classes
      den.aspects.persist._.class._.transformers
    ];
  };
}
