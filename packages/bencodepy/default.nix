{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "bencodepy";
  version = "0.9.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-r0chNNc+pY7as8LLLyz2HrnXg5CChMPS1bHP0434ZLg=";
  };

  # No test suite shipped in the sdist.
  doCheck = false;

  meta = {
    description = "Bencode encoder/decoder for Python (BitTorrent's serialization format)";
    homepage = "https://pypi.org/project/bencodepy/";
    license = lib.licenses.gpl2Only;
  };
}
