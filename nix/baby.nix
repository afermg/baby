{                               # 
  lib,
  # build deps
  buildPythonPackage,
  fetchFromGitHub,
  pip,
  setuptools,
    aiohttp,
    matplotlib,
    numpy,
    pandas,
    imageio,
  pillow,
  keras,
    requests,
    scikit-image,
    scikit-learn,
    scipy,
    hatchling,
    tensorflow,
    # tensorflow-metal,
    tqdm,
  # test deps
  # pytest,
  # cython,
  # runtime deps
  # deprecation,
  # numpy,
  # scipy,
  # scikit-image,
}:
let
  packageOverrides = self: super: {
    numpy = super.numpy.overridePythonAttrs(old: rec {
      version = "1.26.4";
      src = super.fetchPypi {
        pname = "numpy";
        inherit version;
        extension = "tar.gz";
        sha256 = "";
      };
    });
  };
in
buildPythonPackage {
  pname = "baby-seg";
  version = "0.30.7";

  src = fetchFromGitHub {
    owner = "afermg";
    repo = "baby";
    rev = "9f52fb019f9570fae1f4bf39b5151e53df94dbd9";
    sha256 = "sha256-kWFSNPeaAFG3NZW64nu9P5farTlFiZGRF06txEkTj6E=" ;
  };
  pyproject = true;
  buildInputs = [
    # cython
    pip
    setuptools
  ];
  propagatedBuildInputs = [
    # deprecation
    # numpy
    # scipy
    # scikit-image
    # pytest
    aiohttp
    matplotlib
    pandas
    imageio
    pillow
    requests
    scikit-image
    scikit-learn
    scipy
    tensorflow
    # tensorflow-metal
    tqdm
    hatchling
    keras
  ];
  pythonImportsCheck = [
  ];

  meta = {
    description = "baby";
    homepage = "https://github.com/afermg/baby" ;
    license = lib.licenses.bsd3;
  };
}
  
