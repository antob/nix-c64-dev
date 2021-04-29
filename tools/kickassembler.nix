{ pkgs }:

pkgs.stdenv.mkDerivation {
    pname = "kickassembler";
    version = "5.19";

    src = pkgs.fetchurl {
        url = http://theweb.dk/KickAssembler/KickAssembler.zip;
        sha256 = "1dbwjabgjaylam68zdvsp880yg6yaydghgllkrg9758mzrpx1yin";
    };

    nativeBuildInputs = [ pkgs.unzip pkgs.makeWrapper ];

    sourceRoot = ".";
    installPhase = ''
        install -Dm644 KickAss.jar $out/share/java/KickAss.jar
        install -Dm644 KickAss3To4Converter.jar $out/share/java/KickAss3To4Converter.jar

        makeWrapper ${pkgs.jre}/bin/java $out/bin/kickass \
            --add-flags "-jar $out/share/java/KickAss.jar"

        makeWrapper ${pkgs.jre}/bin/java $out/bin/kickass3to4converter \
            --add-flags "-jar $out/share/java/KickAss3To4Converter.jar"
    '';

    meta = with pkgs.lib; {
        description = "An advanced MOS 65xx assembler combined with a Java Script like script language.";
        license = licenses.unfree;
        platforms = platforms.linux;
    };
}
