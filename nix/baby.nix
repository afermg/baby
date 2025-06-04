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

  # src = ./..; # For local testing, add flag --impure when running
  src = fetchFromGitHub {
    owner = "afermg";
    repo = "baby";
    rev = "c2f6d6bb76c1b7b83adae95132bb70c9a894367f";
    sha256 = "sha256-q4NvE3OhIgwMnORHE3Ab1bdZt3mHf3MZ6WWE2xquBR0=";
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
