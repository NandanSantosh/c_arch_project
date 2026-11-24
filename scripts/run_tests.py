#!/usr/bin/env python3
"""Run the generated FFT tests on kites-cli and check every output.

Usage (from the repo root, after scripts/generate_inputs.py):
    python3 scripts/run_tests.py                 # every size in test_cases/
    python3 scripts/run_tests.py --sizes 64 256

For each test, all 3 versions are run with the same input. Reported:
    SNR vs numpy   : each output vs float64 np.fft.fft of its own stored input
    SNR vs scalar  : vector outputs vs the scalar fp32 output
Dumps go to out/tests/{N}/. Instruction counts are not needed here
(control flow does not depend on the input); use fft_guide/run_all.sh.
Exit code 1 if any test fails.
"""

import argparse
import subprocess
import sys
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
from outputs_comparision import compare, decode, load_dump  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
KITES = ROOT / "build" / "kites-cli"
KINDS = ("p", "cmpl_conj_mulj", "fp16")
FMT = {"p": "fp32", "cmpl_conj_mulj": "fp32", "fp16": "fp16"}
# minimum SNR vs numpy to pass
MIN_SNR = {"p": 100.0, "cmpl_conj_mulj": 100.0, "fp16": 50.0}


def read_input(asm):
    """Input x[] exactly as stored in the .s file (.float pairs or fp16 .word)."""
    vals, fmt, in_x = [], None, False
    for line in asm.read_text().splitlines():
        line = line.split("#")[0].strip()
        if line == "x:":
            in_x = True
            continue
        if not in_x or not line:
            continue
        if line.startswith(".float"):
            fmt = "fp32"
            vals += [float(v) for v in line[6:].split(",")]
        elif line.startswith(".word"):
            fmt = "fp16"
            vals += [int(v, 0) for v in line[5:].split(",")]
        else:
            break
    if fmt == "fp32":
        v = np.array(vals, dtype=np.float32).astype(float)
        return v[0::2] + 1j * v[1::2]
    w = np.array(vals, dtype=np.uint32)
    h = lambda u: u.astype(np.uint16).view(np.float16).astype(float)
    return h(w & 0xFFFF) + 1j * h(w >> 16)


def snr(y, ref):
    rel = np.linalg.norm(y - ref) / np.linalg.norm(ref)
    return 20 * np.log10(1 / rel) if rel else np.inf


def run_kites(asm, dump, n, kind):
    rows = n // 2 if kind == "fp16" else n
    cmd = [str(KITES), str(asm), "-o", "_test_run.csv",   # keep instruction_counts.csv intact
           "--mem-dump", "0x10000000", str(rows), "--mem-output", str(dump)]
    r = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
    if r.returncode != 0 or not dump.exists():
        raise RuntimeError(f"kites-cli failed on {asm.name}:\n{r.stderr}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sizes", type=int, nargs="+")
    a = ap.parse_args()

    sizes = a.sizes or sorted(int(p.name) for p in (ROOT / "test_cases").iterdir()
                              if p.name.isdigit())
    failures = 0
    for n in sizes:
        tdir, odir = ROOT / "test_cases" / str(n), ROOT / "out" / "tests" / str(n)
        odir.mkdir(parents=True, exist_ok=True)
        tests = sorted({p.stem.split("_test_")[1] for p in tdir.glob("fft_p_test_*.s")})
        print(f"\n== N = {n}  ({len(tests)} tests)   SNR in dB")
        print(f"{'test':<6}{'scalar':>9}{'vec32':>9}{'fp16':>9}"
              f"{'vec32~sc':>11}{'fp16~sc':>10}{'exact32':>10}  result")
        stats = []
        for t in tests:
            res = {}
            for kind in KINDS:
                asm = tdir / f"fft_{kind}_test_{t}.s"
                dump = odir / f"fft_{kind}_test_{t}.json"
                run_kites(asm, dump, n, kind)
                y = decode(load_dump(dump), FMT[kind])
                res[kind] = snr(y, np.fft.fft(read_input(asm)))
            c32 = compare(odir / f"fft_p_test_{t}.json", odir / f"fft_cmpl_conj_mulj_test_{t}.json")
            c16 = compare(odir / f"fft_p_test_{t}.json", odir / f"fft_fp16_test_{t}.json")
            ok = all(res[k] >= MIN_SNR[k] for k in KINDS) and c32["pass"] and c16["pass"]
            failures += not ok
            stats.append([res["p"], res["cmpl_conj_mulj"], res["fp16"], c32["snr"], c16["snr"]])
            print(f"{t:<6}{res['p']:>9.1f}{res['cmpl_conj_mulj']:>9.1f}{res['fp16']:>9.1f}"
                  f"{c32['snr']:>11.1f}{c16['snr']:>10.1f}{c32['exact']:>6}/{n:<4}"
                  f"  {'PASS' if ok else 'FAIL'}")
        s = np.array(stats)
        print(f"{'min':<6}" + "".join(f"{v:>9.1f}" for v in s.min(0)[:3])
              + f"{s.min(0)[3]:>11.1f}{s.min(0)[4]:>10.1f}")
        print(f"{'mean':<6}" + "".join(f"{v:>9.1f}" for v in s.mean(0)[:3])
              + f"{s.mean(0)[3]:>11.1f}{s.mean(0)[4]:>10.1f}")

    print(f"\n{'ALL PASS' if not failures else f'{failures} test(s) FAILED'}")
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
