#!/usr/bin/env python3
"""Compare FFT implementations using weighted instruction counts.

Expected layout:
    build/
        fft_compare.py
        instructions_count/
            basic_fft_counts.csv
            with_fma.csv
            ...

Each CSV must contain the columns Mnemonic and Execution_Count.

Weighted Cost = sum(Execution_Count * Assumed_Latency). This is an estimate,
not measured processor cycles; it does not model pipelining, overlap,
dependencies, or stalls.
"""

import csv
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CSV_DIR = ROOT / "instructions_count"

CSV_FILES = {
    "Basic FFT": CSV_DIR / "basic_fft_counts.csv",
    "With FMA": CSV_DIR / "with_fma.csv",
    "Without vmul/vswap (8)": CSV_DIR / "without_vmul_vswap_8_counts.csv",
    "With vmul/vswap (8)": CSV_DIR / "with_vmul_vswap_8_counts.csv",
    "Without vmul/vswap (32)": CSV_DIR / "without_vmul_vswap_32_counts.csv",
    "With vmul/vswap (32)": CSV_DIR / "with_vmul_vswap_32_counts.csv",
    "With cmpl (8)": CSV_DIR / "with_cmpl_8_counts.csv",
    "With cmpl (32)": CSV_DIR / "with_cmpl_32_counts.csv",
    "With conj/mulj": CSV_DIR / "with_conj_mulj.csv",
    "With 4 lanes": CSV_DIR / "with_4lanes.csv",
}

SCALAR_LATENCIES = {
    "fadd": 4, "fadd.s": 4,
    "fsub": 4, "fsub.s": 4,
    "fmul": 5, "fmul.s": 5,
    "fdiv": 20, "fdiv.s": 20,
    "fsgnj.s": 1,
    "fmadd.s": 5, "fmsub.s": 5,
}

VECTOR_LATENCY_SCENARIOS = {
    "Optimistic": {
        "vld": 2, "vsd": 1, "vadd": 3, "vsub": 3,
        "vmul": 4, "vswap": 1, "vcmpl": 7,
        "vconj": 1, "vmulj": 1,
    },
    "Moderate": {
        "vld": 2, "vsd": 1, "vadd": 4, "vsub": 4,
        "vmul": 5, "vswap": 1, "vcmpl": 9,
        "vconj": 1, "vmulj": 1,
    },
    "Conservative": {
        "vld": 3, "vsd": 2, "vadd": 5, "vsub": 5,
        "vmul": 6, "vswap": 2, "vcmpl": 12,
        "vconj": 2, "vmulj": 2,
    },
}

LOAD_MNEMONICS = {
    "lb", "lbu", "lh", "lhu", "lw", "lwu", "ld",
    "flw", "fld", "load",
}

STORE_MNEMONICS = {
    "sb", "sh", "sw", "sd", "fsw", "fsd", "store",
}

LATENCY_ONE_PREFIXES = (
    "add", "sub", "mul", "div", "rem",
    "and", "or", "xor", "sll", "srl", "sra",
    "slt", "slti", "lui", "auipc",
    "beq", "bne", "blt", "bge", "bltu", "bgeu",
    "jal", "jalr", "ebreak",
)


def normalize_vector_mnemonic(mnemonic):
    """Normalize spellings such as vadd.h or vadd.vv to vadd."""
    if mnemonic.startswith("v"):
        return mnemonic.split(".", 1)[0]
    return mnemonic


def get_latency(mnemonic, vector_latencies):
    mnemonic = mnemonic.strip().lower()

    if mnemonic in SCALAR_LATENCIES:
        return SCALAR_LATENCIES[mnemonic]

    vector_mnemonic = normalize_vector_mnemonic(mnemonic)
    if vector_mnemonic in vector_latencies:
        return vector_latencies[vector_mnemonic]

    if mnemonic in LOAD_MNEMONICS or mnemonic.startswith("vle"):
        return 2

    if mnemonic in STORE_MNEMONICS or mnemonic.startswith("vse"):
        return 1

    if mnemonic.startswith(LATENCY_ONE_PREFIXES):
        return 1

    return None


def read_counts(csv_path):
    counts = {}

    with csv_path.open("r", newline="", encoding="utf-8-sig") as file:
        reader = csv.DictReader(file)

        if not reader.fieldnames:
            raise ValueError("CSV is empty or has no header")

        required = {"Mnemonic", "Execution_Count"}
        if not required.issubset(set(reader.fieldnames)):
            raise ValueError(
                "Expected columns Mnemonic,Execution_Count; "
                f"found {reader.fieldnames}"
            )

        for row in reader:
            mnemonic = (row.get("Mnemonic") or "").strip()
            raw_count = (row.get("Execution_Count") or "").strip()

            if not mnemonic:
                continue

            try:
                count = int(raw_count)
            except ValueError as error:
                raise ValueError(
                    f"Invalid Execution_Count {raw_count!r} "
                    f"for mnemonic {mnemonic!r}"
                ) from error

            if count < 0:
                raise ValueError(
                    f"Negative Execution_Count for mnemonic {mnemonic!r}"
                )

            counts[mnemonic] = counts.get(mnemonic, 0) + count

    return counts


def calculate_result(name, csv_path, counts, vector_latencies):
    latencies = {
        mnemonic: get_latency(mnemonic, vector_latencies)
        for mnemonic in counts
    }

    unknown = sorted(
        mnemonic for mnemonic, latency in latencies.items()
        if latency is None
    )

    if unknown:
        print(
            f"\n[ERROR] {name}: no latency assigned for: "
            f"{', '.join(unknown)}"
        )
        return None

    return {
        "name": name,
        "path": csv_path,
        "counts": counts,
        "total": sum(counts.values()),
        "cost": sum(
            count * latencies[mnemonic]
            for mnemonic, count in counts.items()
        ),
    }


def print_scenario_results(scenario_name, results):
    print(f"\n{'=' * 105}")
    print(f"{scenario_name.upper()} VECTOR LATENCY SCENARIO")
    print("=" * 105)
    print(
        f"{'Implementation':<39}"
        f"{'Instructions':>22}"
        f"{'Weighted Cost':>22}"
        f"{'Improvement':>18}"
    )
    print("-" * 105)

    baseline = next(
        (result for result in results if result["name"] == "Basic FFT"),
        None,
    )

    for result in results:
        if baseline and baseline["cost"] != 0:
            improvement = (
                (baseline["cost"] - result["cost"]) / baseline["cost"]
            ) * 100
            improvement_text = f"{improvement:.3f}%"
        else:
            improvement_text = "N/A"

        if baseline and result["name"] == "Basic FFT":
            improvement_text = "Baseline"

        print(
            f"{result['name']:<39}"
            f"{result['total']:>22,}"
            f"{result['cost']:>22,}"
            f"{improvement_text:>18}"
        )

    if baseline is None:
        print("\n[NOTE] Basic FFT CSV is unavailable; improvement is not calculated.")


def main():
    print("FFT IMPLEMENTATION COMPARISON")
    print("=" * 105)
    print(f"Reading CSV files from: {CSV_DIR}")

    loaded = {}
    for name, csv_path in CSV_FILES.items():
        if not csv_path.is_file():
            print(f"[SKIP] {name}: CSV not found: {csv_path}")
            continue

        try:
            loaded[name] = (csv_path, read_counts(csv_path))
        except (OSError, ValueError) as error:
            print(f"[ERROR] {name}: {error}")

    if not loaded:
        print("\nNo valid CSV files found.")
        return 1

    for scenario_name, vector_latencies in VECTOR_LATENCY_SCENARIOS.items():
        results = []

        for name, (csv_path, counts) in loaded.items():
            result = calculate_result(
                name, csv_path, counts, vector_latencies
            )
            if result is not None:
                results.append(result)

        if results:
            print_scenario_results(scenario_name, results)

    print("\n" + "=" * 105)
    print("FORMULA: Weighted Cost = sum(Execution_Count x Assumed_Latency)")
    print("This is an estimate, not measured CPU cycles.")
    print("It does not account for pipelining, overlap, dependencies, or stalls.")
    print("=" * 105)
    return 0


if __name__ == "__main__":
    sys.exit(main())
