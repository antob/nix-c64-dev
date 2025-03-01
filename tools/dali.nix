{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "dali";
  version = "v1.2";

  src = pkgs.fetchFromGitHub {
    owner = "bboxy";
    repo = "bitfire";
    rev = version;
    sha256 = "sha256-GJk69HO2VausNRcemur8Kw7eDxw5kTwpqTYGwKmNBu8=";
    fetchSubmodules = true;
  };
  sourceRoot = "source/packer/dali";

  nativeBuildInputs = [
    pkgs.acme
    pkgs.hexdump
  ];

  installPhase = ''
    install -Dm755 dali $out/bin/dali
  '';

  meta = with pkgs.lib; {
    description = "A zx0-reencoder for bitfire by Tobias Bindhammer";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
