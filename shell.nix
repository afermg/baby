with import <nixpkgs> { };
with pkgs.python3Packages;

buildPythonPackage rec {
  name = "mypackage";
  src = ./python/baby;
  propagatedBuildInputs = [
    pytest
    numpy
    pkgs.libsndfile
  ];
}
