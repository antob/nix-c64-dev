{ xa, pkgs
, withUI ? "sdlui2"
, ossSupport ? false
, alsaSupport ? pkgs.stdenv.hostPlatform.isLinux
, pulseSupport ? pkgs.stdenv.hostPlatform.isLinux
, videoSupport ? true
, networkingSupport ? !pkgs.stdenv.hostPlatform.isDarwin
, hardwareSupport ? !pkgs.stdenv.hostPlatform.isDarwin
}:

assert pkgs.lib.assertOneOf "withUI" withUI [ "sdlui" "sdlui2" "native-gtk3ui" "debug-gtk3ui" "headlessui" ];

let
  inherit (pkgs.lib) optional optionals optionalString;
  configureOnOff = (ifTrue: ifFalse: name: value: if value then "--${ifTrue}-${name}" else "--${ifFalse}-${name}");
  configureEnableYesNo = (name: value: "--enable-${name}=${if value then "yes" else "no"}");
  configureEnableDisable = (name: value: configureOnOff "enable" "disable" name value);
  configureWithWithout = (name: value: configureOnOff "with" "without" name value);
  withGTK = (withUI == "native-gtk3ui" || withUI == "debug-gtk3ui");
in
pkgs.stdenv.mkDerivation rec {
  pname = "vice";
  version = "3.5";

  desktopItem = pkgs.makeDesktopItem {
    name = "vice";
    exec = "x64sc";
    comment = "Commodore 64 emulator";
    desktopName = "VICE";
    genericName = "Commodore 64 emulator";
    categories = "Emulator;";
  };

  src = pkgs.fetchurl {
    url = "mirror://sourceforge/vice-emu/${pname}-${version}.tar.gz";
    sha256 = "03nwcldg2h7dxj6aa77ggqc0442hqc1lsq5x69h8kcmqmvx7ifan";
  };

  patches = [ ./vice.patch ]; # Fixes `SDL_image.h: No such file or directory`

  nativeBuildInputs = [
    pkgs.autoreconfHook pkgs.makeWrapper pkgs.pkg-config pkgs.bison pkgs.flex pkgs.perl pkgs.texinfo pkgs.file pkgs.doxygen pkgs.libiconv pkgs.dos2unix xa
  ]
  ++ optional withGTK pkgs.wrapGAppsHook;

  buildInputs = [ pkgs.libpng pkgs.giflib pkgs.libjpeg pkgs.readline pkgs.zlib pkgs.lame pkgs.mpg123 pkgs.flac pkgs.libvorbis ]
  ++ optional pkgs.stdenv.hostPlatform.isLinux pkgs.libpcap
  ++ optional alsaSupport pkgs.alsaLib
  ++ optional pulseSupport pkgs.libpulseaudio
  ++ optional videoSupport pkgs.ffmpeg
  ++ optionals hardwareSupport [ pkgs.libieee1284 pkgs.pciutils ]
  ++ optionals (withUI == "sdlui") [ pkgs.SDL ]
  ++ optionals (withUI == "sdlui2") [ pkgs.SDL2 pkgs.SDL2_image ]
  ++ optionals withGTK [ pkgs.gtk3 pkgs.libGL pkgs.glew ];

  postPatch = "patchShebangs .";

  # configure: error: invalid option: --disable-static
  dontDisableStatic = true;

  enableParallelBuilding = true;

  configureFlags = [
    (configureWithWithout "readline" true)
    (configureWithWithout "pulse" pulseSupport)
    (configureWithWithout "alsa" alsaSupport)
    (configureWithWithout "oss" ossSupport)
    (configureWithWithout "sun" false)
    (configureWithWithout "sdlsound" false)
    (configureWithWithout "resid" true)
    (configureWithWithout "jpeg" false) # FIXME cannot find jpeglib.h
    (configureWithWithout "png" true)
    (configureWithWithout "gif" true)
    (configureWithWithout "zlib" true)
    (configureWithWithout "zlib" true)

    (configureEnableDisable withUI true)
    (configureEnableDisable "hwscale" true)
    (configureEnableDisable "realdevice" true)
    (configureEnableDisable "external-ffmpeg" videoSupport)
    (configureEnableDisable "quicktime" videoSupport)
    (configureEnableDisable "ethernet" networkingSupport)
    (configureEnableDisable "ipv6" networkingSupport)
    (configureEnableDisable "ssi2001" true)
    (configureEnableDisable "catweasel" hardwareSupport)
    (configureEnableDisable "hardsid" hardwareSupport)
    (configureEnableDisable "parsid" hardwareSupport)
    (configureEnableDisable "libieee1284" hardwareSupport)
    (configureEnableDisable "portaudio" false)
    (configureEnableDisable "ahi" true)
    (configureEnableDisable "cpuhistory" true)
    (configureEnableDisable "lame" true)
    (configureEnableDisable "static-lame" false)
    (configureEnableDisable "rs232" true)
    (configureEnableDisable "midi" true)
    (configureEnableDisable "platformdox" false)
    (configureEnableDisable "embedded" false) # Extremely broken with 3.5
    (configureEnableDisable "hidmgr" pkgs.stdenv.hostPlatform.isDarwin)
    (configureEnableDisable "hidutils" pkgs.stdenv.hostPlatform.isDarwin)
    (configureEnableDisable "debug" false)
    (configureEnableDisable "native-tools" false)
    (configureEnableDisable "pdf-docs" false)

    (configureEnableDisable "inline" true)
    (configureEnableYesNo "arch" false)
    (configureEnableDisable "no-pic" false)
    (configureEnableDisable "new8580filter" false)
    (configureEnableDisable "x64" false)
  ];

  preBuild = ''
    for i in src/resid{,-dtv}; do
      mkdir -pv $i/src
      ln -sv ../../wrap-u-ar.sh $i/src
    done
  '';

  postInstall = optionalString (pkgs.stdenv.hostPlatform.isLinux) ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  # to prevent double wrapping
  dontWrapGApps = withGTK;

  postFixup = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        "''${gappsWrapperArgs[@]}" \
        --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.ffmpeg pkgs.lame ]}"
    done
  '';

  meta = with pkgs.lib; {
    description = "Commodore 64, 128 and other emulators";
    homepage = "http://www.viceteam.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    broken = (withUI == "headlessui") || (pkgs.stdenv.hostPlatform.isDarwin && withGTK);
  };
}
