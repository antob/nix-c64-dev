{ pkgs }:

let
  usockets = pkgs.gcc13Stdenv.mkDerivation {
    pname = "uSockets";
    version = "0.8.8";

    src = pkgs.fetchFromGitHub {
      owner = "uNetworking";
      repo = "uSockets";
      rev = "v0.8.8";
      sha256 = "sha256-ZlyY2X0aDdjfV0zjcecOLaozwp1crDibx6GBbUnDyAk=";
    };

    patchPhase = ''
      sed -i 's/lib.exe.*|| //' ./Makefile
    '';

    buildPhase = ''
      AR=gcc-ar make -j$(nproc)
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';

    meta = with pkgs.lib; {
      description = "µSockets is the non-blocking, thread-per-CPU foundation library used by µWebSockets.";
      homepage = "https://github.com/uNetworking/uSockets";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };

  mtengine = pkgs.gcc13Stdenv.mkDerivation {
    pname = "MTEngineSDL";
    version = "3.15";

    src = pkgs.fetchFromGitHub {
      owner = "slajerek";
      repo = "MTEngineSDL";
      rev = "ccea4c7";
      sha256 = "sha256-eOILPCb2piSYHCOla4uKJzaCnE4Pau6XTVhwixYL1n4=";
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
      cmake
      clang
    ];
    buildInputs = with pkgs; [
      SDL2
      gtk3
      alsa-lib
    ];

    inherit usockets;
    patchPhase = ''
      cp -f "$usockets/uSockets.a" ./platform/Linux/libs/uSockets.a
    '';

    installPhase = ''
      mkdir -p $out
      cp -r ../. $out
    '';

    meta = with pkgs.lib; {
      description = "A SDL2+ImGui engine for macOS, Linux and MS Windows.";
      homepage = "https://github.com/slajerek/MTEngineSDL";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

in
pkgs.gcc13Stdenv.mkDerivation {
  pname = "RetroDebugger";
  version = "0.64.72";

  src = pkgs.fetchFromGitHub {
    owner = "slajerek";
    repo = "RetroDebugger";
    rev = "v0.64.72";
    sha256 = "sha256-p67FC4LJr+HII6+jwI0SaEt6qC4wUguCDmi4UdOzgMs=";
  };

  inherit mtengine;

  unpackPhase = ''
    runHook preUnpack

    mkdir -p ./MTEngineSDL
    mkdir -p ./RetroDebugger

    cp -r "$mtengine/." ./MTEngineSDL
    cp -r "$src/." ./RetroDebugger

    sourceRoot=./RetroDebugger
    runHook postUnpack
  '';

  nativeBuildInputs = with pkgs; [
    pkg-config
    cmake
    makeWrapper
  ];
  buildInputs = with pkgs; [
    SDL2
    gtk3
    glew
    sndio
    dbus
    alsa-lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./retrodebugger $out/bin

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/retrodebugger --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.zenity ]}
  '';

  meta = with pkgs.lib; {
    description = "A multiplatform debugger APIs host for retro computers: C64 (Vice), Atari800 and NES (NestopiaUE).";
    homepage = "https://github.com/slajerek/RetroDebugger";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
