{ lib, stdenv, fetchurl, bison, flex, perl, libpng, giflib, libjpeg, alsa-lib, readline, libGLU, libGL, libXaw
, pkg-config, gtk2, SDL, autoreconfHook, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "vice";
  version = "3.1";

  src = fetchurl {
    url = "mirror://sourceforge/vice-emu/vice-${version}.tar.gz";
    sha256 = "0h0jbml02s2a36hr78dxv1zshmfhxp1wadpcdl09aq416fb1bf1y";
  };

  buildInputs = [ bison flex perl libpng giflib libjpeg alsa-lib readline libGLU libGL
    pkg-config gtk2 SDL autoreconfHook libXaw ];
  dontDisableStatic = true;
  configureFlags = [ "--enable-fullscreen --enable-gnomeui" ];

  desktopItem = makeDesktopItem {
    name = "vice";
    exec = "x64";
    comment = "Commodore 64 emulator";
    desktopName = "VICE";
    genericName = "Commodore 64 emulator";
    categories = "Emulator;";
  };

  preBuild = ''
    for i in src/resid src/resid-dtv
    do
        mkdir -pv $i/src
        ln -sv ../../wrap-u-ar.sh $i/src
    done
  '';
  patchPhase = ''
    # Disable font-cache update
    sed -i -e "s|install: install-data-am|install-no: install-data-am|" data/fonts/Makefile.am
  '';

  #NIX_LDFLAGS = "-lX11 -L${libX11}/lib";

  postInstall = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = {
    description = "Commodore 64, 128 and other emulators";
    homepage = "http://www.viceteam.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
