#!/usr/bin/env python3
"""Check a Kites memory dump against numpy's FFT of the same input.

Usage:
    python3 fft_guide/check_fft.py <program.s> <dump.json> [--scalar N_p.json] [--golden other.json]

The input x[] is read from the .s file itself, so any input works.
  .float re, im  lines -> fp32 (8 bytes per sample)
  .word  0xIIIIRRRR    -> packed fp16 (4 bytes per sample)
--scalar: also measure the difference from the scalar fp32 run (N_p.json).
--golden: also compare the x[] region bit-for-bit with another dump.
"""
import argparse, json, re
import numpy as np

BASE = 0x10000000  # .data starts here; x: is the first label


def read_input(asm_path):
    vals, fmt, in_x = [], None, False
    for line in open(asm_path):
        line = line.split("#")[0].strip()
        if not line:
            continue
        if re.match(r"^x:\s*$", line):
            in_x = True
            continue
        if in_x and re.match(r"^\w+:", line):
            break
        if in_x and line.startswith(".float"):
            fmt = "fp32"
            vals += [float(v) for v in line[6:].split(",")]
        elif in_x and line.startswith(".word"):
            fmt = "fp16"
            vals += [int(v, 0) for v in line[5:].split(",")]
    if fmt == "fp32":
        v = np.array(vals, dtype=np.float32).astype(float)
        return v[0::2] + 1j * v[1::2], fmt
    w = np.array(vals, dtype=np.uint32)
    h = lambda u: u.astype(np.uint16).view(np.float16).astype(float)
    return h(w & 0xFFFF) + 1j * h(w >> 16), fmt


def read_dump(path, n_bytes):
    mem = {}
    for a, v in json.load(open(path)).items():
        a, v = int(a, 16), int(v, 16)
        for i in range(8):
            mem[a + i] = (v >> (8 * i)) & 0xFF
    return bytes(mem.get(BASE + i, 0) for i in range(n_bytes))


def decode(raw, fmt):
    if fmt == "fp32":
        v = np.frombuffer(raw, dtype="<f4").astype(float)
        return v[0::2] + 1j * v[1::2]
    v = np.frombuffer(raw, dtype="<f2").astype(float)
    return v[0::2] + 1j * v[1::2]


def report(tag, y, ref):
    e = np.abs(y - ref)
    rel = np.linalg.norm(e) / np.linalg.norm(ref)
    print(f"[{tag}] max abs err {e.max():.4g} (bin {e.argmax()}) | "
          f"rel L2 {rel:.3e} | SNR {20*np.log10(1/rel):.1f} dB | "
          f"PSNR {20*np.log10(np.abs(ref).max()/np.sqrt((e**2).mean())):.1f} dB")


def main():
    ap = argparse.ArgumentParser(usage=__doc__)
    ap.add_argument("asm"); ap.add_argument("dump")
    ap.add_argument("--scalar", help="memory dump of the scalar fp32 run (N_p.json)")
    ap.add_argument("--golden", help="dump to compare bit-for-bit")
    a = ap.parse_args()

    x, fmt = read_input(a.asm)
    N = len(x)
    nbytes = N * (8 if fmt == "fp32" else 4)
    raw = read_dump(a.dump, nbytes)
    y = decode(raw, fmt)
    X = np.fft.fft(x)  # float64 reference on the exact stored input

    print(f"N = {N}, format = {fmt}, X[0] = {y[0]:.6g} (numpy {X[0]:.6g})")
    report("vs numpy f64", y, X)
    if a.scalar:
        s = decode(read_dump(a.scalar, N * 8), "fp32")
        report("vs scalar   ", y, s)
    if not np.all(np.isfinite(y)):
        print("WARNING: inf/NaN in output")

    if a.golden:
        g = read_dump(a.golden, nbytes)
        step = 8 if fmt == "fp32" else 4
        same = sum(raw[i:i+step] == g[i:i+step] for i in range(0, nbytes, step))
        print(f"bit-exact vs golden: {same}/{N} samples")


if __name__ == "__main__":
    main()
