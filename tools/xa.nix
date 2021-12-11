{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "xa";
  version = "2.3.12";

  src = pkgs.fetchzip {
    url = "https://www.floodgap.com/retrotech/${pname}/dists/${pname}-${version}.tar.gz";
    sha256 = "oUehxf7mBeYCUO6Kv9KdQ+tcNvFowgaNIwzaGbXIiKk=";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "CC:=$(CC)"
    "LD:=$(CC)"
  ];

  meta = with pkgs.lib; {
    description = "Andre Fachat's open-source 6502 cross assembler.";
    homepage = "https://www.floodgap.com/retrotech/xa/";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
