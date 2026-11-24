#!/usr/bin/env python3
"""Generate FFT test programs with random inputs.

For every size N and test number, the same random input is written into
all three versions (scalar / fp32 vector / fp16 vector).

Usage (from the repo root):
    python3 scripts/generate_inputs.py                     # N = 16 64 256 1024, 10 tests
    python3 scripts/generate_inputs.py --sizes 64 --tests 5 --seed 2000

Reads:   assembly_codes/{N}_p.s, {N}_cmpl_conj_mulj.s, {N}_fp16.s
Writes:  test_cases/{N}/fft_{kind}_test_XX.s
         test_cases/{N}/fft_test_XX_input.json   (fp32 input, dump format)
"""

import argparse
import json
import random
import re
import struct
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parent.parent
ASM_DIR = ROOT / "assembly_codes"
OUTPUT_DIR = ROOT / "test_cases"
KINDS = ("p", "cmpl_conj_mulj", "fp16")
BASE = 0x10000000           # .data base; x: is the first label


# --------------------------------------------------
# FLOATING-POINT UTILITIES
# --------------------------------------------------

def to_float32(value):
    return struct.unpack("<f", struct.pack("<f", value))[0]


def float32_bits(value):
    return struct.unpack("<I", struct.pack("<f", value))[0]


def float16_bits(value):
    return int(np.array(value, dtype=np.float16).view(np.uint16))


# --------------------------------------------------
# RANDOM INPUT
# --------------------------------------------------

def generate_samples(seed, n):
    """n complex samples, re/im uniform in [-1, 1], rounded to fp32."""
    rng = random.Random(seed)
    return [(to_float32(rng.uniform(-1, 1)), to_float32(rng.uniform(-1, 1)))
            for _ in range(n)]


# --------------------------------------------------
# REPLACE THE x: DATA BLOCK
# --------------------------------------------------

def data_lines(samples, fmt):
    if fmt == "fp32":
        return [f"    .float {r:.9g}, {i:.9g}    # x[{k}]"
                for k, (r, i) in enumerate(samples)]
    # fp16: one word per sample = (imag << 16) | real
    return [f"    .word 0x{(float16_bits(i) << 16) | float16_bits(r):08X}    # x[{k}]"
            for k, (r, i) in enumerate(samples)]


def replace_fft_input(text, samples):
    """Replace the .float/.word lines directly under 'x:'; keep everything else."""
    lines = text.splitlines()
    start = next(k for k, l in enumerate(lines) if re.match(r"^\s*x:\s*$", l)) + 1
    end = start
    while end < len(lines) and lines[end].strip().startswith((".float", ".word")):
        end += 1
    old = lines[start:end]
    if len(old) != len(samples):
        raise RuntimeError(f"x: has {len(old)} samples, expected {len(samples)}")
    fmt = "fp16" if old[0].strip().startswith(".word") else "fp32"
    return "\n".join(lines[:start] + data_lines(samples, fmt) + lines[end:]) + "\n"


# --------------------------------------------------
# SAVE INPUT AS JSON (same format as kites-cli memory dumps)
# --------------------------------------------------

def save_packed_json(samples, path):
    """Low 32 bits = real, high 32 bits = imaginary (fp32)."""
    mem = {f"0x{BASE + 8 * k:016x}":
           f"0x{(float32_bits(i) << 32) | float32_bits(r):016x}"
           for k, (r, i) in enumerate(samples)}
    path.write_text(json.dumps(mem, indent=4))


# --------------------------------------------------
# MAIN
# --------------------------------------------------

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sizes", type=int, nargs="+", default=[16, 64, 256, 1024])
    ap.add_argument("--tests", type=int, default=10)
    ap.add_argument("--seed", type=int, default=1000, help="seed of test 00")
    a = ap.parse_args()

    total = 0
    for n in a.sizes:
        bases = {k: ASM_DIR / f"{n}_{k}.s" for k in KINDS}
        missing = [str(p) for p in bases.values() if not p.exists()]
        if missing:
            raise FileNotFoundError("missing: " + ", ".join(missing))
        texts = {k: p.read_text() for k, p in bases.items()}

        out = OUTPUT_DIR / str(n)
        out.mkdir(parents=True, exist_ok=True)
        for t in range(a.tests):
            seed = a.seed + t
            samples = generate_samples(seed, n)
            for kind, text in texts.items():
                (out / f"fft_{kind}_test_{t:02d}.s").write_text(
                    replace_fft_input(text, samples))
            save_packed_json(samples, out / f"fft_test_{t:02d}_input.json")
            total += len(KINDS)
        print(f"N = {n:<5} {a.tests} tests (seeds {a.seed}..{a.seed + a.tests - 1}) -> {out}")

    print(f"Generated {total} assembly files in {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
