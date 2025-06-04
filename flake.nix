             {
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/d97b37430f8f0262f97f674eb357551b399c2003";
    nixpkgs_master.url = "github:NixOS/nixpkgs/master";
    systems.url = "github:nix-systems/default";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      systems,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          system = system;
          config.allowUnfree = true;
          config.cudaSupport = true;
        };
        # tpkgs = import (builtins.fetchGit {
        # # Descriptive name to make the store path easier to identify
        # name = "tensorflow_packages" ;
        # url = "https://github.com/NixOS/nixpkgs/";
        # ref = "refs/heads/nixpkgs-unstable";
        # rev = "";
        # }) { };

      in
      with pkgs;
      rec {
        # py311 = (
        #   pkgs.python311.override {
        #     packageOverrides = pyself: pysuper: {
        #       pytest-doctestplus = pysuper.pytest-doctestplus.overridePythonAttrs {
        #         nativeCheckInputs = [ pysuper.numpy ];
        #       };
        #     };
        #   }
        # );
        # tpkgsp = tpkgs.python311.override {
        #   self = pkgs.python311;
        #   packageOverrides = pyself: pysuper: {
        #     fs = py311.pkgs.fs;
        #     pynacl = py311.pkgs.pynacl;
        #     deprecated = py311.pkgs.deprecated;
        #     eventlet = py311.pkgs.eventlet;
        #     paramiko = py311.pkgs.paramiko;
        #   };
 
        # };
        
        packages = {
          baby = pkgs.python311.pkgs.callPackage ./nix/baby.nix { };
        };
        devShells = {
          default =
            let
              python_with_pkgs = (
                pkgs.python311.withPackages (pp: [
                  packages.baby
                ])
              );
            in
            mkShell {
              packages = [
                python_with_pkgs
              ];
              currentSystem = system;
              venvDir = "./.venv";
              postVenvCreation = ''
                unset SOURCE_DATE_EPOCH
              '';
              postShellHook = ''
                unset SOURCE_DATE_EPOCH
              '';
              shellHook = ''
                runHook venvShellHook
                export PYTHONPATH=${python_with_pkgs}/${python_with_pkgs.sitePackages}:$PYTHONPATH
              '';
            };
        };
      }
    );
}
