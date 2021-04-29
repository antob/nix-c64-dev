{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "xa";
  version = "2.3.11";

  src = pkgs.fetchzip {
    url = "https://www.floodgap.com/retrotech/${pname}/dists/${pname}-${version}.tar.gz";
    sha256 = "1wz6l0ms97sja5frrhng2k9a7rh19g6z1iq88g42w93w2sn42fg7";
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
