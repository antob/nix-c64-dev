{ pkgs }:

pkgs.stdenv.mkDerivation rec {
    pname = "c64debugger";
    version = "0.64.58.2";

    src = pkgs.fetchgit {
        url = "https://git.code.sf.net/p/c64-debugger/code";
        rev = "0e993f4ac3f9690d2984ac35e24b15bc026aab82";
        sha256 = "mym8dtPvXXuPSE1Z3hVZbVQKarmShtCbZqHE4/Fd1yE=";
    };

    sourceRoot = "code-0e993f4/MTEngine"; # ???

    enableParallelBuilding = true;
    buildInputs = [ pkgs.pkg-config pkgs.gtk3 pkgs.xorg.libX11 pkgs.xorg.xcbutil pkgs.alsaLib pkgs.libGL pkgs.libGLU ];
    nativeBuildInputs = [ pkgs.upx ];

    installPhase = ''
        install -Dm755 ./c64debugger $out/bin/c64debugger
    '';

    meta = with pkgs.lib; {
        description = "Commodore 64, Atari XL/XE and NES debugger that works in real time.";
        license = licenses.gpl3;
        platforms = platforms.linux;
    };
}
