{
  imports = [
    ./L0HXJUDK.nix
    ./L0HXJWTK.nix
    ./L0HZ3Z4J.nix
    ./L0HZ7KRJ.nix
    ./L0HZBXEJ.nix
  ];
  disko.devices.disk = {
    zpool = {
      zroot = {
        type = "zpool";
        mode = "raidz2";
        options.cachefile = "none";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "true";
          redundant_metadata = "most";
        };
      };
    };
  };
}
