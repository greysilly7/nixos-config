{ den, ... }:
{
  den.aspects.cli._.tools._.sys-tools = den.lib.perHost {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.iotop # Real-time I/O monitor
          pkgs.iftop # Display bandwidth usage on an interface by host
          pkgs.strace # System call tracer for Linux
          pkgs.ltrace # Library call tracer
          pkgs.lsof # Tool to list open files
        ];
      };
  };
}
