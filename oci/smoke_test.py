#!/usr/bin/env python3
"""End-to-end smoke inference against the BABY OCI container."""

import json
import os

import numpy as np
import requests

MODELSET = "yeast-alcatras-brightfield-sCMOS-60x-1z"


def main() -> None:
    address = os.environ.get("BABY_ADDRESS", "http://127.0.0.1:5101")
    models_response = requests.get(f"{address}/models", timeout=60)
    models_response.raise_for_status()
    models = models_response.json()
    modelset = MODELSET if MODELSET in models else models[0]

    session_response = requests.get(f"{address}/session/{modelset}", timeout=60)
    session_response.raise_for_status()
    session_id = session_response.json()["sessionid"]

    image = np.random.default_rng(42).integers(
        0, 256, size=(1, 80, 120, 1), dtype=np.uint8
    )
    segment_response = requests.post(
        f"{address}/segment",
        params={"sessionid": session_id},
        files=[
            ("dims", ("", json.dumps(list(image.shape)))),
            ("bitdepth", ("", "8")),
            ("img", ("", image.tobytes(order="F"))),
            ("refine_outlines", ("", "true")),
            ("with_edgemasks", ("", "true")),
            ("with_masks", ("", "true")),
        ],
        timeout=900,
    )
    segment_response.raise_for_status()

    result_response = requests.get(
        f"{address}/segment", params={"sessionid": session_id}, timeout=900
    )
    result_response.raise_for_status()
    result = result_response.json()

    assert isinstance(result, list) and len(result) == 1, result
    assert "cell_label" in result[0], result[0].keys()
    print(
        json.dumps(
            {
                "modelset": modelset,
                "tiles": len(result),
                "cells": len(result[0]["cell_label"]),
            }
        )
    )


if __name__ == "__main__":
    main()
