{ pkgs }:

pkgs.stdenv.mkDerivation {
    pname = "exomizer";
    version = "3.0.2";

    src = pkgs.fetchurl {
        url = https://bitbucket.org/magli143/exomizer/wiki/downloads/exomizer-3.0.2.zip;
        sha256 = "0xb0n4cd94hny3g68jd5qim19f5ajz207dvbhj4l843cwvcs556g";
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
