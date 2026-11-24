#!/usr/bin/env python3
"""Compare a scalar FFT memory dump with a vector (fp32 or fp16) dump.

Usage:
    python3 scripts/outputs_comparision.py scalar.json vector.json [--tol 1e-5]

Dump formats (detected automatically from the number of rows):
    fp32: N rows, one complex per 64-bit row (low 32 = real, high 32 = imag)
    fp16: N/2 rows, two complex per row, each a 32-bit word (imag<<16 | real)

Scalar and vector round in a different order, so bit-exact equality is not
expected. PASS if the relative L2 difference <= tol
(default 1e-5 for fp32, 5e-3 for fp16).
"""

import argparse
import json
import sys

import numpy as np


def load_dump(filename):
    with open(filename, encoding="utf-8") as f:
        data = json.load(f)
    if not isinstance(data, dict):
        raise ValueError(f"{filename}: expected a JSON object")
    rows = sorted((int(a, 16), int(v, 16)) for a, v in data.items())
    return np.array([v for _, v in rows], dtype=np.uint64)


def decode(words, fmt):
    """64-bit rows -> complex array."""
    raw = words.astype("<u8").tobytes()
    dt = "<f4" if fmt == "fp32" else "<f2"
    v = np.frombuffer(raw, dtype=dt).astype(float)
    return v[0::2] + 1j * v[1::2]


def compare(scalar_file, vector_file, tol=None):
    s_words, v_words = load_dump(scalar_file), load_dump(vector_file)
    n = len(s_words)
    if len(v_words) == n:
        fmt = "fp32"
    elif 2 * len(v_words) == n:
        fmt = "fp16"
    else:
        raise ValueError(f"row counts {n} / {len(v_words)}: not N/N or N/(N/2)")
    s, v = decode(s_words, "fp32"), decode(v_words, fmt)
    if tol is None:
        tol = 1e-5 if fmt == "fp32" else 5e-3

    e = np.abs(v - s)
    rel = np.linalg.norm(e) / np.linalg.norm(s)
    exact = int(np.sum(s_words == v_words)) if fmt == "fp32" else None
    return {"N": n, "fmt": fmt, "max_abs": e.max(), "bin": int(e.argmax()),
            "rel": rel, "snr": 20 * np.log10(1 / rel) if rel else np.inf,
            "exact": exact, "tol": tol,
            "finite": bool(np.all(np.isfinite(v))),
            "pass": bool(rel <= tol and np.all(np.isfinite(v))),
            "s": s, "v": v}


def main():
    ap = argparse.ArgumentParser(usage=__doc__)
    ap.add_argument("scalar")
    ap.add_argument("vector")
    ap.add_argument("--tol", type=float, help="max relative L2 difference")
    a = ap.parse_args()

    r = compare(a.scalar, a.vector, a.tol)
    print("FFT memory dump comparison (vector vs scalar)")
    print(f"Scalar file : {a.scalar}")
    print(f"Vector file : {a.vector}  ({r['fmt']})")
    print(f"N           : {r['N']}")
    if r["exact"] is not None:
        print(f"Bit-exact   : {r['exact']}/{r['N']} samples")
    print(f"Max abs diff: {r['max_abs']:.6g}  (bin {r['bin']})")
    print(f"Rel L2 diff : {r['rel']:.3e}   SNR vs scalar: {r['snr']:.1f} dB")
    if not r["finite"]:
        print("WARNING: inf/NaN in vector output")

    worst = np.argsort(np.abs(r["v"] - r["s"]))[::-1][:5]
    print("\nLargest differences:")
    for k in worst:
        print(f"  X[{k:4d}]  scalar {r['s'][k]:.6g}   vector {r['v'][k]:.6g}")

    print(f"\nRESULT: {'PASS' if r['pass'] else 'FAIL'} "
          f"(rel L2 {r['rel']:.2e} {'<=' if r['pass'] else '>'} tol {r['tol']:.0e})")
    sys.exit(0 if r["pass"] else 1)


if __name__ == "__main__":
    main()
