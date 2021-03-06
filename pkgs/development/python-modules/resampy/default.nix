{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytest-cov
, numpy
, scipy
, cython
, numba
, six
}:

buildPythonPackage rec {
  pname = "resampy";
  version = "0.2.2";

  # No tests in PyPi Archive
  src = fetchFromGitHub {
    owner = "bmcfee";
    repo = pname;
    rev = version;
    sha256 = "0qmkxl5sbgh0j73n667vyi7ywzh09iaync91yp1j5rrcmwsn0qfs";
  };

  checkInputs = [ pytest pytest-cov ];
  propagatedBuildInputs = [ numpy scipy cython numba six ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://github.com/bmcfee/resampy";
    description = "Efficient signal resampling";
    license = licenses.isc;
  };

}
