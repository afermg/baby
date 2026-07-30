# BABY Nahual OCI image

The Nix flake builds a reproducible, OCI-compatible image archive containing the
same dependency closure used by `nix run`. The image requires neither Nix nor a
Python environment at runtime and is loadable by Podman and Docker.

BABY is the legacy exception to the standard Nahual NNG endpoint: `baby-phone`
serves its established HTTP API on port 5101 rather than NNG on port 5555.

## Build and load

```console
nix build .#oci-image
podman load < result
# Or: docker load < result
```

The local image name is `nahual/baby:local`.

## Run

`/tmp/nahual` contains downloaded BABY model sets and should be persisted:

```console
podman run --rm --name nahual-baby \
  -p 5101:5101 \
  -v nahual-baby-cache:/tmp/nahual \
  nahual/baby:local
```

The TensorFlow build can use an NVIDIA GPU when the host runtime exposes one.
For Podman add `--device nvidia.com/gpu=all`; for Docker add `--gpus all`.
CPU inference works without either option.

## Full smoke inference

In another environment with Python (Nix is not needed):

```console
python3 -m venv .venv
. .venv/bin/activate
pip install numpy requests
BABY_ADDRESS=http://127.0.0.1:5101 python oci/smoke_test.py
```

The test creates a session for the standard bright-field model, submits a
synthetic NYXZ uint8 image through the multipart HTTP API, waits for full model
inference, and validates the segmentation response.
