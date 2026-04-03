{ den, ... }:
{
  den.aspects.cli._.tools._.cli-tools = den.lib.perHost {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.parted # CLI program for creating and manipulating partition tables
          pkgs.file # Program that shows the type of files
          pkgs.tree # Command to produce a depth indented directory listing
          pkgs.which # Shows the full path of (shell) commands
          pkgs.wget2 # Tool for retrieving files using HTTP, HTTPS, and FTP
          pkgs.curl # Command line tool for transferring files with URL syntax
          pkgs.gnused # GNU sed, a batch stream editor
          pkgs.gawk # GNU implementation of the Awk programming language
          pkgs.jq # Lightweight and flexible command-line JSON processor
        ];
      };
  };
}
