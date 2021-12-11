{ pkgs }:

pkgs.stdenv.mkDerivation {
    pname = "kickassembler";
    version = "5.23";

    src = pkgs.requireFile {
        name = "KickAssembler.zip";
        url = "http://theweb.dk/KickAssembler/KickAssembler.zip";
        sha256 = "1ss161gghwcvk89qmqz2zgykzp1z5plqardz40yaqlxdc5gljay6";
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
