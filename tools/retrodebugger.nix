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
    version = "3.16";

    src = pkgs.fetchFromGitHub {
      owner = "slajerek";
      repo = "MTEngineSDL";
      rev = "bebe82880c17209faf953380d8d2c6febe101c2b";
      sha256 = "sha256-pwjlJt/t8oOO25EVEf+toFJ8sBYcEyY5Y6gDuoSNLzM=";
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
      mkdir -p ./platform/Linux/libs
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
  version = "0.64.74";

  src = pkgs.fetchFromGitHub {
    owner = "slajerek";
    repo = "RetroDebugger";
    rev = "v0.64.74";
    sha256 = "sha256-VBqAL+/BDpm0qPIcV62Zb+Ha/qE6qCSdDCa/AYBG8oA=";
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
    autoPatchelfHook
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
