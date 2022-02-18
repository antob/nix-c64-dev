{ pkgs }:

let
  mtengine = pkgs.stdenv.mkDerivation rec {
    pname = "MTEngineSDL";
    version = "2021-02-18";
  
    src = pkgs.fetchFromGitHub {
      owner = "slajerek";
      repo = "MTEngineSDL";
      rev = "19b5295d875c197ec03bc20ddacd48c228920365";
      sha256 = "VGx3s3aG24cCxNBGSwRupNeBQM4scRz9vQou0T4DVZg=";
    };
  
    nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];
    buildInputs = [ pkgs.SDL2 pkgs.gtk3 ];
  
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
  pkgs.stdenv.mkDerivation {
    pname = "RetroDebugger";
    version = "2021-02-18";
  
    src = pkgs.fetchFromGitHub {
      owner = "slajerek";
      repo = "RetroDebugger";
      rev = "9bb81a2649fe476c3e409a4a62a159c9dc1be630";
      sha256 = "pqzKlRMcbjntY9N/MwagS3K5xkitbxJ+WwQV6ejl7VA=";
    };

    mtengine = mtengine;
    unpackPhase = ''
      runHook preUnpack

      mkdir -p ./MTEngineSDL
      mkdir -p ./RetroDebugger

      cp -r "$mtengine/." ./MTEngineSDL
      cp -r "$src/." ./RetroDebugger

      sourceRoot=./RetroDebugger
      runHook postUnpack
    '';

    patchPhase = ''
      sed -i 's|/usr/lib/x86_64-linux-gnu/libsndio.so|sndio|g' ./CMakeLists.txt
    '';
  
    nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake pkgs.makeWrapper ];
    buildInputs = [ pkgs.SDL2 pkgs.gtk3 pkgs.glew pkgs.sndio pkgs.dbus ];

    installPhase = ''
      runHook preInstall
      
      mkdir -p $out/bin
      cp ./retrodebugger $out/bin

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/retrodebugger --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.gnome.zenity ]}
    '';

    meta = with pkgs.lib; {
      description = "A multiplatform debugger APIs host for retro computers: C64 (Vice), Atari800 and NES (NestopiaUE).";
      homepage = "https://github.com/slajerek/RetroDebugger";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  }
