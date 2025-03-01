{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "spindle";
  version = "3.1";

  src = pkgs.fetchurl {
    url = "https://hd0.linusakesson.net/files/spindle-${version}.zip";
    sha256 = "sha256-Srv3V+1VDR2nqsPZ8EzxBWah9ukHl4DgL4TP1KFkQxs=";
  };

  nativeBuildInputs = [
    pkgs.unzip
    pkgs.xa
  ];

  sourceRoot = "spindle-${version}/src";
  installPhase = ''
    install -Dm755 mkpef $out/bin/mkpef
    install -Dm755 pef2prg $out/bin/pef2prg
    install -Dm755 pefchain $out/bin/pefchain
    install -Dm755 spin $out/bin/spin
  '';

  meta = with pkgs.lib; {
    description = "An integrated linking, loading and decrunching solution for C64 trackmos";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
