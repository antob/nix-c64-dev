{ pkgs }:

pkgs.stdenv.mkDerivation rec {
    pname = "dali";
    version = "2022-02-21";

    src = pkgs.fetchFromGitHub {
        owner = "bboxy";
        repo = "bitfire";
        rev = "1b0203d9aaadd103be408be34ebd4e4f3b1403e1";
        sha256 = "O0qHqqhxR07wsG0PlWi67QJdj0NWIUEhPnx71461jOQ=";
        fetchSubmodules = true;
    };
    sourceRoot = "source/packer/dali";

    nativeBuildInputs = [ pkgs.acme ];

    installPhase = ''
        install -Dm755 dali $out/bin/dali
    '';

    meta = with pkgs.lib; {
        description = "A zx0-reencoder for bitfire by Tobias Bindhammer";
        license = licenses.bsd3;
        platforms = platforms.all;
    };
}
