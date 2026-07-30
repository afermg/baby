{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/d97b37430f8f0262f97f674eb357551b399c2003";
    nixpkgs_master.url = "github:NixOS/nixpkgs/master";
    systems.url = "github:nix-systems/default";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    systems,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          system = system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };
        py311 = pkgs.python311.override {
          packageOverrides = _: super: {
            scikit-learn = super.scikit-learn.overridePythonAttrs (old: rec {
              version = "1.2.2";
              # Skip checks, as a few fail but they are irrelevant.
              doCheck = false;
              src = super.fetchPypi {
                pname = "scikit-learn";
                inherit version;
                hash = "sha256-hCmuow7CTnqMftij+mITrfOBSm776gnhbgoMceGho9c=";
              };
            });
          };
        };
        modelPackages = {
          baby = py311.pkgs.callPackage ./nix/baby.nix {};
        };
        runServer = pkgs.writeScriptBin "nahual-baby" ''
          #!${pkgs.bash}/bin/bash
          echo "Running baby-phone from ${modelPackages.baby}"
          exec ${modelPackages.baby}/bin/baby-phone "$@"
        '';
        serverApp = {
          type = "app";
          program = "${runServer}/bin/nahual-baby";
        };
      in
        with pkgs; rec {
          apps.default = serverApp;
          inherit py311;
          packages =
            modelPackages
            // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
              oci-image = import ./nix/oci-image.nix {
                inherit pkgs;
                name = "baby";
                title = "Nahual BABY";
                description = "BABY budding-yeast segmentation and lineage server";
                source = "https://github.com/afermg/baby";
                revision = self.rev or self.dirtyRev or "unknown";
                server = runServer;
                entrypoint = serverApp.program;
                port = 5101;
                cmd = [
                  "--port"
                  "5101"
                  # Nix Python dependencies are injected into the entry point's
                  # sys.path; loky's fresh worker interpreter cannot recover
                  # that path. One in-process worker is reliable in containers.
                  "--njobs"
                  "1"
                ];
              };
            };
          devShells = {
            default = let
              python_with_pkgs = (
                py311.withPackages (pp: [
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
