
import csv
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent

CSV_FILES = {
    "Scalar": ROOT / "text" / "scalar_counts.csv",
    "Vector": ROOT / "text" / "vector_counts.csv",
    "Hybrid": ROOT / "text" / "hybrid_counts.csv",
}

# Assumed instruction latencies in cycles
EXACT_LATENCIES = {
    "fadd": 4, "fadd.s": 4,
    "fsub": 4, "fsub.s": 4,
    "fmul": 5, "fmul.s": 5,
    "fdiv": 20, "fdiv.s": 20,
    "fsgnj.s": 1,
    "vld": 2, "vsd": 1,
    "vadd": 4, "vsub": 4,
    "vmul": 5, "vswap": 1,
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


def get_latency(mnemonic):
    mnemonic = mnemonic.strip().lower()

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
                f"Expected columns Mnemonic,Execution_Count; "
                f"found {reader.fieldnames}"
            )

        for row in reader:
            mnemonic = (row.get("Mnemonic") or "").strip()
            raw_count = (row.get("Execution_Count") or "").strip()

            if not mnemonic:
                continue

            count = int(raw_count)
            counts[mnemonic] = counts.get(mnemonic, 0) + count

    return counts


def analyse(name, csv_path):
    if not csv_path.is_file():
        print(f"[SKIP] {name}: CSV not found: {csv_path}")
        return None

    counts = read_counts(csv_path)

    unknown = sorted(
        mnemonic for mnemonic in counts
        if get_latency(mnemonic) is None
    )

    if unknown:
        print(
            f"\n[ERROR] {name}: latency not assigned for: "
            f"{', '.join(unknown)}"
        )
        return None

    total = sum(counts.values())

    cost = sum(
        count * get_latency(mnemonic)
        for mnemonic, count in counts.items()
    )

    return {
        "name": name,
        "counts": counts,
        "total": total,
        "cost": cost,
    }


def main():
    print("FFT Scalar vs Vector vs Hybrid comparison")
    print("=" * 65)

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

    print("\nWEIGHTED COST SUMMARY")
    print("-" * 65)
    print(f"{'Implementation':<20}{'Instructions':>20}{'Weighted Cost':>20}")
    print("-" * 65)

    for result in results:
        print(
            f"{result['name']:<20}"
            f"{result['total']:>20,}"
            f"{result['cost']:>20,}"
        )

    scalar = next(
        (r for r in results if r["name"] == "Scalar"),
        None
    )

    if scalar and scalar["cost"] != 0:
        print("\nIMPROVEMENT RELATIVE TO SCALAR")
        print("-" * 45)

        for result in results:
            if result["name"] == "Scalar":
                continue

            improvement = (
                (scalar["cost"] - result["cost"])
                / scalar["cost"]
            ) * 100

            print(
                f"{result['name']}: {improvement:.3f}%"
            )

    print("\nPER-MNEMONIC DYNAMIC INSTRUCTION COUNTS")
    print("-" * 75)

    names = [r["name"] for r in results]

    print(f"{'Mnemonic':<18}", end="")

    for name in names:
        print(f"{name:>18}", end="")

    print()
    print("-" * 75)

    all_mnemonics = sorted({
        mnemonic
        for result in results
        for mnemonic in result["counts"]
    })

    by_name = {r["name"]: r for r in results}

    for mnemonic in all_mnemonics:
        print(f"{mnemonic:<18}", end="")

        for name in names:
            count = by_name[name]["counts"].get(mnemonic, 0)
            print(f"{count:>18,}", end="")

        print()

    print("\nFormula: Weighted Cost = sum(Count x Assumed Latency)")
    print("This is an estimate, not measured CPU cycles.")
    print("It does not account for pipelining, overlap, or stalls.")

    return 0


if __name__ == "__main__":
    sys.exit(main())

PY
