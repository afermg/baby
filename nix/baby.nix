{
  lib,
  # build deps
  buildPythonPackage,
  fetchFromGitHub,
  pip,
  setuptools,
  aiohttp,
  matplotlib,
  pandas,
  imageio,
  keras,
  requests,
  scikit-image,
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

  src = /home/amunoz/projects/baby;
  #   fetchFromGitHub {
  #   owner = "afermg";
  #   repo = "baby";
  #   rev = "fdd0a0c04f1568d7b2bc07cf6365ae779e2dceb5";
  #   sha256 = "sha256-POGN7xV7VOZ4ruBqrRub8+9Rer9/46yLgSLp6Ab8AFw=";
  # };

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
    scikit-image
    scikit-image
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
