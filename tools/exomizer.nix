{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "exomizer";
  version = "3.1.2";

  src = pkgs.fetchurl {
    url = "https://bitbucket.org/magli143/exomizer/wiki/downloads/exomizer-${version}.zip";
    sha256 = "sha256-iJYoXkjonim6livDfY9NzVBqlXU+2bjr9g5DiTw2zjo=";
  };

  nativeBuildInputs = [ pkgs.unzip ];

  sourceRoot = "src";
  installPhase = ''
    install -Dm755 exomizer $out/bin/exomizer
    install -Dm755 exobasic $out/bin/exobasic
  '';

  meta = with pkgs.lib; {
    description = "Exomizer is a program that compresses files in a way that tries to be as efficient as possible but still allows them to be decompressed in environments where CPU speed and RAM are limited.";
    license = licenses.zlib; # ???
    platforms = platforms.linux;
  };
}
