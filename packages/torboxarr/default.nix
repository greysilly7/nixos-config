{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "torboxarr";
  version = "main";

  src = fetchFromGitHub {
    owner = "MrJoiny";
    repo = "TorBoxarr";
    rev = "main";
    hash = "sha256-C0JPOvgodHJKUiBw2ACxtswWDoGP7hEzL3sF635QBjc=";
  };

  vendorHash = "sha256-qjDuMhTaQ8A3cmqtSlMlADrWC0iKOgyR8zShYC4Ute4=";

  meta = with lib; {
    description = "Pretends to be qBittorrent or SABnzbd so your *arr apps can use TorBox as a download backend";
    homepage = "https://github.com/MrJoiny/TorBoxarr";
    license = licenses.mit;
    mainProgram = "torboxarr";
  };
}
