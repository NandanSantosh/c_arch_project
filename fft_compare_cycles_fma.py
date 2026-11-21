
import csv
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent

CSV_FILES = {
    "Basic FFT": ROOT / "text" / "basic_fft_counts.csv",
    "With FMA": ROOT / "text" / "with_fma.csv",
}

# Assumed instruction latencies in cycles
EXACT_LATENCIES = {
    "fadd": 4, "fadd.s": 4,
    "fsub": 4, "fsub.s": 4,
    "fmul": 5, "fmul.s": 5,
    "fdiv": 20, "fdiv.s": 20,
    "fsgnj.s": 1,

    # Fused multiply-add/subtract
    "fmadd.s": 5,
    "fmsub.s": 5,
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

    if mnemonic in LOAD_MNEMONICS:
        return 2

    if mnemonic in STORE_MNEMONICS:
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
        if get_latency(mnemonic) is None
    )

    if unknown:
        print(
            f"\n[ERROR] {name}: latency not assigned for: "
            f"{', '.join(unknown)}"
        )
        return None

    total_cost = sum(
        count * get_latency(mnemonic)
        for mnemonic, count in counts.items()
    )

    return {
        "name": name,
        "counts": counts,
        "total": sum(counts.values()),
        "cost": total_cost,
    }


def print_cost_summary(results):
    print("\nWEIGHTED COST SUMMARY")
    print("-" * 75)

    print(
        f"{'Implementation':<25}"
        f"{'Instructions':>20}"
        f"{'Weighted Cost':>25}"
    )

    print("-" * 75)

    for result in results:
        print(
            f"{result['name']:<25}"
            f"{result['total']:>20,}"
            f"{result['cost']:>25,}"
        )

    baseline = next(
        (result for result in results if result["name"] == "Basic FFT"),
        None
    )

    if baseline is None:
        return

    print("\nIMPROVEMENT RELATIVE TO BASIC FFT")
    print("-" * 75)

    for result in results:
        if result["name"] == "Basic FFT":
            continue

        base = baseline["cost"]
        current = result["cost"]

        improvement = (
            (base - current) / base * 100
            if base else 0
        )

        print(f"{result['name']}: {improvement:.3f}%")


def print_mnemonic_counts(results):
    print("\nPER-MNEMONIC DYNAMIC INSTRUCTION COUNTS")
    print("-" * 75)

    names = [result["name"] for result in results]

    print(f"{'Mnemonic':<18}", end="")

    for name in names:
        print(f"{name:>25}", end="")

    print()
    print("-" * 75)

    all_mnemonics = sorted({
        mnemonic
        for result in results
        for mnemonic in result["counts"]
    })

    by_name = {
        result["name"]: result
        for result in results
    }

    for mnemonic in all_mnemonics:
        print(f"{mnemonic:<18}", end="")

        for name in names:
            count = by_name[name]["counts"].get(mnemonic, 0)
            print(f"{count:>25,}", end="")

        print()


def main():
    print("FFT: Basic vs FMA Comparison")
    print("=" * 75)

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
    print("These are latency-based estimates, not measured CPU cycles.")
    print("The calculation does not model pipelining, instruction overlap,")
    print("resource conflicts, dependencies, or pipeline stalls.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
