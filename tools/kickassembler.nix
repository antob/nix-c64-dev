{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "kickassembler";
  version = "5.25";

  src = pkgs.fetchzip {
    url = "http://theweb.dk/KickAssembler/KickAssembler.zip";
    sha256 = "sha256-9qjnqK5sGdl3wCsewcEMtYeNX3b7M82arO2tJn6YpxE=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    pkgs.makeWrapper
  ];

  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/share/java
    install -Dm644 source/KickAss.jar $out/share/java/KickAss.jar

    makeWrapper ${pkgs.jre}/bin/java $out/bin/kickass \
        --add-flags "-jar $out/share/java/KickAss.jar"
  '';

  meta = with pkgs.lib; {
    description = "An advanced MOS 65xx assembler combined with a Java Script like script language.";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
