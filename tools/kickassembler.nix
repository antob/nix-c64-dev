{ pkgs }:

pkgs.stdenv.mkDerivation {
    pname = "kickassembler";
    version = "5.20";

    src = pkgs.requireFile {
        name = "KickAssembler.zip";
        url = "http://theweb.dk/KickAssembler/KickAssembler.zip";
        sha256 = "0qcy3ccyv1148z2ympxl49bb7zlc0zvkdmksjr1q85mcvha314ll";
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
