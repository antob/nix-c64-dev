{ pkgs }:

pkgs.stdenv.mkDerivation {
    pname = "kickassembler";
    version = "5.19";

    src = pkgs.fetchurl {
        url = http://theweb.dk/KickAssembler/KickAssembler.zip;
        sha256 = "lJIwFNysFoRDlnrWNvcHjP6zViK03+rFRySE7RkbnmE=";
    };

    nativeBuildInputs = [ pkgs.unzip pkgs.makeWrapper ];

    sourceRoot = ".";
    installPhase = ''
        install -Dm644 KickAss.jar $out/share/java/KickAss.jar

        makeWrapper ${pkgs.jre}/bin/java $out/bin/kickass \
            --add-flags "-jar $out/share/java/KickAss.jar"
    '';

    meta = with pkgs.lib; {
        description = "An advanced MOS 65xx assembler combined with a Java Script like script language.";
        license = licenses.unfree;
        platforms = platforms.linux;
    };
}
