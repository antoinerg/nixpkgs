{ lib, stdenv, fetchurl, pkg-config, mount, libuuid
, macfuse-stubs, DiskArbitration
, crypto ? false, libgcrypt, gnutls
}:

stdenv.mkDerivation rec {
  pname = "ntfs3g";
  version = "2021.8.22";

  outputs = [ "out" "dev" "man" "doc" ];

  buildInputs = [ libuuid ] ++ lib.optionals crypto [ gnutls libgcrypt ]
    ++ lib.optionals stdenv.isDarwin [ macfuse-stubs DiskArbitration ];
  nativeBuildInputs = [ pkg-config ];

  src = fetchurl {
    url = "https://tuxera.com/opensource/ntfs-3g_ntfsprogs-${version}.tgz";
    sha256 = "55b883aa05d94b2ec746ef3966cb41e66bed6db99f22ddd41d1b8b94bb202efb";
  };

  patchPhase = ''
    substituteInPlace src/Makefile.in --replace /sbin '@sbindir@'
    substituteInPlace ntfsprogs/Makefile.in --replace /sbin '@sbindir@'
    substituteInPlace libfuse-lite/mount_util.c \
      --replace /bin/mount ${mount}/bin/mount \
      --replace /bin/umount ${mount}/bin/umount
  '';

  configureFlags = [
    "--disable-ldconfig"
    "--exec-prefix=\${prefix}"
    "--enable-mount-helper"
    "--enable-posix-acls"
    "--enable-xattr-mappings"
    "--${if crypto then "enable" else "disable"}-crypto"
    "--enable-extras"
  ];

  postInstall =
    ''
      # Prefer ntfs-3g over the ntfs driver in the kernel.
      ln -sv mount.ntfs-3g $out/sbin/mount.ntfs
    '';

  meta = with lib; {
    homepage = "https://github.com/tuxera/ntfs-3g";
    description = "FUSE-based NTFS driver with full write support";
    maintainers = with maintainers; [ dezgeg ];
    platforms = with platforms; darwin ++ linux;
    license = with licenses; [
      gpl2Plus # ntfs-3g itself
      lgpl2Plus # fuse-lite
    ];
  };
}
