{ lib, stdenv, fetchurl, libxml2, openssl, readline, gawk }:

stdenv.mkDerivation rec {
  pname = "virtuoso-opensource";
  version = "6.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/virtuoso/${pname}-${version}.tar.gz";
    sha256 = "0dx0lp7cngdchi0772hp93zzn6sdap7z8s3vay3mzb9xgf0sdgy6";
  };

  outputs = [ "out" "dev" "doc" ];

  buildInputs = [ libxml2 openssl readline gawk ];

  CPP = "${stdenv.cc}/bin/gcc -E";

  configureFlags = [
    "--enable-shared" "--disable-all-vads" "--with-readline=${readline.dev}"
    "--disable-hslookup" "--disable-wbxml2" "--without-iodbc"
    "--enable-openssl=${openssl.dev}"
  ];

  postInstall = ''
    echo Moving documentation
    mkdir -pv $out/share/doc
    mv -v $out/share/virtuoso/doc $out/share/doc/${pname}-${version}

    echo Removing jars and empty directories
    find $out -name "*.a" -delete -o -name "*.jar" -delete -o -type d -empty -delete

    for f in $out/lib/*.la; do
      echo "Fixing $f"
      substituteInPlace $f \
        --replace "${readline.dev}" "${readline.out}/lib" \
        --replace "${openssl.dev}/lib" "${openssl.out}/lib"
    done
  '';

  meta = with lib; {
    description = "SQL/RDF database used by, e.g., KDE-nepomuk";
    homepage = "http://virtuoso.openlinksw.com/dataspace/dav/wiki/Main/";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
