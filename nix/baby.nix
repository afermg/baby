{
  lib,
  # build deps
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  matplotlib,
  pandas,
  imageio,
  keras,
  requests,
  scikitimage,
  scikit-learn,
  scipy,
  hatchling,
  tensorflow,
  tqdm,
  # test deps
  pytest,
}:
buildPythonPackage {
  pname = "baby-seg";
  version = "0.30.7";

  # src = ./..; # For local testing, add flag --impure when running
  src = fetchFromGitHub {
    owner = "afermg";
    repo = "baby";
    rev = "39eec0d4c3b8fad9b0a8683cbedf9b4558e07222";
    sha256 = "sha256-ptLXindgixDa4AV3x+sQ9I4W0PScIQMkyMNMo0WFa0M=";
  };

  pyproject = true;
  buildInputs = [
    hatchling
  ];
  propagatedBuildInputs = [
    aiohttp
    imageio
    keras
    matplotlib
    pandas
    pytest
    requests
    scikitimage
    scikit-learn
    scipy
    tensorflow 
    tqdm
  ];
  
  pythonImportsCheck = [
  ];

  meta = {
    description = "baby";
    homepage = "https://github.com/afermg/baby";
    license = lib.licenses.bsd3;
  };
}
