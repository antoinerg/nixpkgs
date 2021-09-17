{ lib
, buildPythonPackage
, fetchPypi
, plotly
, flask
, flask-compress
, future
, dash-core-components
, dash-renderer
, dash-html-components
, dash-table
, setuptools
, pytest
, pytest-mock
, mock
}:

buildPythonPackage rec {
  pname = "dash";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    /* sha256 = "0930r3cp6rl8li5n94xivghz9cqcpdi9qpzpmf9awvi13qrz2kz5"; */
    sha256 = "1918x9g1lrx97p01dzdlsgwmrbfk1jmy2b0hrdlv15gpw8j7q9r9";
  };

  propagatedBuildInputs = [
    plotly
    flask
    flask-compress
    future
    dash-core-components
    dash-renderer
    dash-html-components
    dash-table
    setuptools
  ];

  /* checkInputs = [
    pytest
    pytest-mock
    mock
  ];

  checkPhase = ''
    pytest tests/unit/test_{configs,fingerprint,resources}.py \
      tests/unit/dash/
  ''; */

  doCheck = false;

  pythonImportsCheck = [
    "dash"
  ];

  meta = with lib; {
    description = "Python framework for building analytical web applications";
    homepage = "https://dash.plot.ly/";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
