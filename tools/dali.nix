{ pkgs }:

pkgs.stdenv.mkDerivation rec {
    pname = "dali";
    version = "2022-05-28";

    src = pkgs.fetchFromGitHub {
        owner = "bboxy";
        repo = "bitfire";
        rev = "efd47244d0026c65b4b618a82c5e7e38ace1a0f4";
        sha256 = "sha256-BsYth8qYAXFNBqZqmCbhLKB6Y8f/fZGW6cXoxvMBTao=";
        fetchSubmodules = true;
    };
    sourceRoot = "source/packer/dali";

    nativeBuildInputs = [ pkgs.acme pkgs.hexdump ];

    installPhase = ''
        install -Dm755 dali $out/bin/dali
    '';

    meta = with pkgs.lib; {
        description = "A zx0-reencoder for bitfire by Tobias Bindhammer";
        license = licenses.bsd3;
        platforms = platforms.all;
    };
}
