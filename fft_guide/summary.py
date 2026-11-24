#!/usr/bin/env python3
"""Instruction counts + weighted latency cost for kites-cli CSVs (-o).

Usage:
    python3 fft_guide/summary.py instructions_count/256_p.csv \
        instructions_count/256_cmpl_conj_mulj.csv instructions_count/256_fp16.csv

Put the scalar CSV first: speedups are relative to the first file.
Latencies come from scripts/fft_compare.py (single source of truth):
    Weighted Cost = sum(Execution_Count x Assumed_Latency)
An estimate only: no pipelining, overlap or stalls.
"""
import importlib.util, sys
from pathlib import Path

# reuse the latency tables + CSV reader from scripts/fft_compare.py
_fc = Path(__file__).resolve().parent.parent / "scripts" / "fft_compare.py"
_spec = importlib.util.spec_from_file_location("fft_compare", _fc)
fc = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(fc)

MEM = {"lw", "sw", "flw", "fsw", "vld", "vsd"}


def main():
    paths = [Path(p) for p in sys.argv[1:]]
    if not paths:
        sys.exit(__doc__)

    rows = []
    for p in paths:
        c = fc.read_counts(p)
        cost = {}
        for scen, lat in fc.VECTOR_LATENCY_SCENARIOS.items():
            unknown = [m for m in c if fc.get_latency(m, lat) is None]
            if unknown:
                sys.exit(f"{p.name}: no latency for {', '.join(unknown)} "
                         f"(add it to scripts/fft_compare.py)")
            cost[scen] = sum(n * fc.get_latency(m, lat) for m, n in c.items())
        rows.append((p.stem, sum(c.values()),
                     sum(n for m, n in c.items() if m.startswith("v")),
                     sum(n for m, n in c.items() if m in MEM), cost))

    scens = list(fc.VECTOR_LATENCY_SCENARIOS)
    b_tot, b_cost = rows[0][1], rows[0][4]
    head = f"{'program':<26}{'instrs':>9}{'vector':>8}{'ld/st':>7}{'speedup':>9}"
    head += "".join(f"{s:>21}" for s in scens)
    print(head)
    print("-" * len(head))
    for name, tot, vec, mem, cost in rows:
        line = f"{name:<26}{tot:>9}{vec:>8}{mem:>7}{b_tot / tot:>8.2f}x"
        line += "".join(f"{cost[s]:>12} ({b_cost[s] / cost[s]:>4.2f}x)" for s in scens)
        print(line)
    print("speedup = first file / this file;  weighted cost columns = "
          "sum(count x latency) per scenario in scripts/fft_compare.py")


if __name__ == "__main__":
    main()
