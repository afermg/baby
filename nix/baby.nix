{
  lib,
  # build deps
  buildPythonPackage,
  fetchFromGitHub,
  pip,
  setuptools,
  aiohttp,
  matplotlib,
  # numpy_1,
  pandas,
  imageio,
  pillow,
  numpy_1,
  keras,
  requests,
  scikit-image,
  scikit-learn,
  scipy,
  hatchling,
  # tensorflow,
  # tensorflow-metal,
  tqdm,
  # test deps
  pytest,
# cython,
# runtime deps
# deprecation,
# numpy,
# scipy,
# scikit-image,
}:
let
  pkgs = import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "tensorflow_packages" ;
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "21808d22b1cda1898b71cf1a1beb524a97add2c4";
  }) { };

  tflow = pkgs.libtensorflow;
  # np = pkgs.numpy_1;
in
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
    # pip
    # setuptools
    hatchling
  ];
  propagatedBuildInputs = [
    aiohttp
    matplotlib
    pandas
    # imageio
    # numpy
    # requests
    scikit-learn
    scipy
    # (scikit-image.overrideAttrs{numpy=numpy_1;}) # Trouble TODO Fix
    (tflow.overrideAttrs {numpy=numpy_1;})
    # tensorflow # TODO downgrade
    # keras # 
    # tensorflow-metal
    tqdm
    # pytest
  ];
  pythonImportsCheck = [
  ];

  meta = {
    description = "baby";
    homepage = "https://github.com/afermg/baby";
    license = lib.licenses.bsd3;
  };
}
