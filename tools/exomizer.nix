{ pkgs }:

pkgs.stdenv.mkDerivation rec {
    pname = "exomizer";
    version = "3.1.1";

    src = pkgs.fetchurl {
        url = "https://bitbucket.org/magli143/exomizer/wiki/downloads/exomizer-${version}.zip";
        sha256 = "0bgyx5ivisrg28dzx9xciayy3674ha39bq2z3giqa0fr40985z1d";
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
