{ den, ... }:
{
  den.aspects.cli._.tools._.archive-tools = den.lib.perHost {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.zip # Compressor/archiver for creating and modifying zip files
          pkgs.unzip # Extraction utility for archives compressed in .zip format
          pkgs.xz # General-purpose data compression software, successor of LZMA
          pkgs.p7zip # 7-Zip file archiver linux port with additional codecs and improvements
          pkgs.gnutar # GNU implementation of the 'tar' archiver
        ];
      };
  };
}
