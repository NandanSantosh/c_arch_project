import csv
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent

CSV_FILES = {
    "Basic FFT": ROOT / "text" / "basic_fft_counts.csv",
    "Without vmul/vswap - 8R": ROOT / "text" / "without_vmul_vswap_8_counts.csv",
    "With vmul/vswap - 8R": ROOT / "text" / "with_vmul_vswap_8_counts.csv",
    "Without vmul/vswap - 32R": ROOT / "text" / "without_vmul_vswap_32_counts.csv",
    "With vmul/vswap - 32R": ROOT / "text" / "with_vmul_vswap_32_counts.csv",
    "With cmpl - 8R": ROOT / "text" / "with_cmpl_8_counts.csv",
    "With cmpl - 32R": ROOT / "text" / "with_cmpl_32_counts.csv",
}

# Scalar instruction latencies, kept constant across all scenarios.
EXACT_LATENCIES = {
    "fadd": 4, "fadd.s": 4,
    "fsub": 4, "fsub.s": 4,
    "fmul": 5, "fmul.s": 5,
    "fdiv": 20, "fdiv.s": 20,
    "fsgnj.s": 1,
}

# Assumed custom-vector latencies for sensitivity analysis.
# These are estimates, not measured hardware latencies.
VECTOR_LATENCY_SCENARIOS = {
    "Optimistic": {
        "vld": 1, "vsd": 1, "vadd": 2, "vsub": 2,
        "vmul": 3, "vswap": 1, "vcmpl": 4,
    },
    "Moderate": {
        "vld": 2, "vsd": 1, "vadd": 4, "vsub": 4,
        "vmul": 5, "vswap": 1, "vcmpl": 8,
    },
    "Conservative": {
        "vld": 3, "vsd": 2, "vadd": 6, "vsub": 6,
        "vmul": 8, "vswap": 2, "vcmpl": 12,
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


def get_latency(mnemonic, vector_latencies):
    mnemonic = mnemonic.strip().lower()

    if mnemonic in vector_latencies:
        return vector_latencies[mnemonic]
    if mnemonic in EXACT_LATENCIES:
        return EXACT_LATENCIES[mnemonic]
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
                f"Expected columns Mnemonic,Execution_Count; found {reader.fieldnames}"
            )

        for row in reader:
            mnemonic = (row.get("Mnemonic") or "").strip()
            raw_count = (row.get("Execution_Count") or "").strip()
            if not mnemonic:
                continue
            try:
                count = int(raw_count)
            except ValueError:
                raise ValueError(
                    f"Invalid Execution_Count {raw_count!r} for {mnemonic!r}"
                )
            counts[mnemonic] = counts.get(mnemonic, 0) + count
    return counts


def analyse(name, csv_path):
    if not csv_path.is_file():
        print(f"[SKIP] {name}: CSV not found: {csv_path}")
        return None

    counts = read_counts(csv_path)
    unknown = sorted(
        mnemonic for mnemonic in counts
        if any(
            get_latency(mnemonic, latencies) is None
            for latencies in VECTOR_LATENCY_SCENARIOS.values()
        )
    )
    if unknown:
        print(f"\n[ERROR] {name}: latency not assigned for: {', '.join(unknown)}")
        return None

    costs = {}
    for scenario, latencies in VECTOR_LATENCY_SCENARIOS.items():
        costs[scenario] = sum(
            count * get_latency(mnemonic, latencies)
            for mnemonic, count in counts.items()
        )

    return {
        "name": name,
        "counts": counts,
        "total": sum(counts.values()),
        "costs": costs,
    }


def print_cost_summary(results):
    print("\nWEIGHTED COST SUMMARY")
    print("-" * 120)
    print(
        f"{'Implementation':<35}"
        f"{'Instructions':>18}"
        f"{'Optimistic':>18}"
        f"{'Moderate':>18}"
        f"{'Conservative':>18}"
    )
    print("-" * 120)

    for result in results:
        print(
            f"{result['name']:<35}"
            f"{result['total']:>18,}"
            f"{result['costs']['Optimistic']:>18,}"
            f"{result['costs']['Moderate']:>18,}"
            f"{result['costs']['Conservative']:>18,}"
        )

    baseline = next(
        (result for result in results if result["name"] == "Basic FFT"),
        None
    )
    if baseline is None:
        print("\n[INFO] Basic FFT CSV unavailable; improvement not calculated.")
        return

    print("\nIMPROVEMENT RELATIVE TO BASIC FFT")
    print("-" * 105)
    print(
        f"{'Implementation':<35}"
        f"{'Optimistic':>18}"
        f"{'Moderate':>18}"
        f"{'Conservative':>18}"
    )
    print("-" * 105)

    for result in results:
        if result["name"] == "Basic FFT":
            continue

        improvement = {}
        for scenario in VECTOR_LATENCY_SCENARIOS:
            base = baseline["costs"][scenario]
            current = result["costs"][scenario]
            improvement[scenario] = ((base - current) / base * 100) if base else 0

        print(
            f"{result['name']:<35}"
            f"{improvement['Optimistic']:>17.3f}%"
            f"{improvement['Moderate']:>17.3f}%"
            f"{improvement['Conservative']:>17.3f}%"
        )


def print_mnemonic_counts(results):
    print("\nPER-MNEMONIC DYNAMIC INSTRUCTION COUNTS")
    print("-" * 150)
    names = [result["name"] for result in results]

    print(f"{'Mnemonic':<18}", end="")
    for name in names:
        print(f"{name:>22}", end="")
    print()
    print("-" * 150)

    all_mnemonics = sorted({
        mnemonic for result in results for mnemonic in result["counts"]
    })
    by_name = {result["name"]: result for result in results}

    for mnemonic in all_mnemonics:
        print(f"{mnemonic:<18}", end="")
        for name in names:
            count = by_name[name]["counts"].get(mnemonic, 0)
            print(f"{count:>22,}", end="")
        print()


def main():
    print("FFT Implementation Comparison")
    print("=" * 120)

    results = []
    for name, path in CSV_FILES.items():
        try:
            result = analyse(name, path)
            if result is not None:
                results.append(result)
        except (OSError, ValueError) as error:
            print(f"[ERROR] {name}: {error}")

    if not results:
        print("\nNo valid CSV results found.")
        return 1

    print_cost_summary(results)
    print_mnemonic_counts(results)

    print("\nFORMULA")
    print("Weighted Cost = sum(Execution Count x Assumed Instruction Latency)")
    print("Optimistic, Moderate, and Conservative use different vector latencies.")
    print("These are weighted latency-based estimates, not measured CPU cycles.")
    print("The calculation does not model pipelining, instruction overlap,")
    print("resource conflicts, dependencies, or pipeline stalls.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
