
import random
import struct
import json
import re
from pathlib import Path

# --------------------------------------------------
# PATH CONFIGURATION
# --------------------------------------------------

BUILD_DIR = Path(__file__).resolve().parent

# Original FFT implementations
BASE_ASM_FILES = {
    "scalar": BUILD_DIR / "1024_p.s",
    "vector": BUILD_DIR / "1024_v.s",
    "vector_no_vmul_vswap": BUILD_DIR / "1024v_1.s",
}

# Generated files
OUTPUT_DIR = BUILD_DIR / "test_cases"


# --------------------------------------------------
# TEST CONFIGURATION
# --------------------------------------------------

NUMBER_OF_TESTS = 10
NUMBER_OF_SAMPLES = 1024


# --------------------------------------------------
# FLOATING-POINT UTILITIES
# --------------------------------------------------

def to_float32(value):
    """Round a Python float to FP32."""
    return struct.unpack("<f", struct.pack("<f", value))[0]


def float32_bits(value):
    """Return the raw 32-bit representation of an FP32 value."""
    return struct.unpack("<I", struct.pack("<f", value))[0]


# --------------------------------------------------
# RANDOM INPUT GENERATION
# --------------------------------------------------

def generate_samples(seed):
    """
    Generate 1024 random complex FP32 samples.
    Each sample contains real and imaginary components.
    """

    rng = random.Random(seed)
    samples = []

    for _ in range(NUMBER_OF_SAMPLES):
        real = to_float32(rng.uniform(-1.0, 1.0))
        imag = to_float32(rng.uniform(-1.0, 1.0))

        samples.append((real, imag))

    return samples


# --------------------------------------------------
# REPLACE FFT INPUT IN ASSEMBLY
# --------------------------------------------------

def replace_fft_input(assembly_text, samples):
    """
    Replace only the x: data block.
    Keep twiddle tables, constants, temporary variables,
    and FFT implementation unchanged.
    """

    pattern = r"(?ms)^x:\s*\n.*?(?=^wlen_table:)"

    data_lines = ["x:\n"]

    for index, (real, imag) in enumerate(samples):
        data_lines.append(
            f"    .float {real:.9g}, {imag:.9g}  # x[{index}]\n"
        )

    replacement = "".join(data_lines)

    updated_text, replacements = re.subn(
        pattern,
        replacement,
        assembly_text,
        count=1
    )

    if replacements != 1:
        raise RuntimeError(
            "Could not find the x: data block followed by wlen_table:. "
            "Check the assembly file labels."
        )

    return updated_text


# --------------------------------------------------
# SAVE INPUT DATA AS JSON
# --------------------------------------------------

def save_packed_json(samples, output_path):
    """
    Save input memory as packed 64-bit complex values.

    Low 32 bits  = real
    High 32 bits = imaginary
    """

    memory = {}

    for index, (real, imag) in enumerate(samples):

        real_bits = float32_bits(real)
        imag_bits = float32_bits(imag)

        word = (imag_bits << 32) | real_bits

        address = index * 8

        memory[f"0x{address:04X}"] = f"0x{word:016X}"

    with open(output_path, "w") as file:
        json.dump(memory, file, indent=2)


# --------------------------------------------------
# MAIN TEST GENERATION
# --------------------------------------------------

def main():

    # Check that all three original assembly files exist
    for implementation, asm_file in BASE_ASM_FILES.items():

        if not asm_file.exists():
            raise FileNotFoundError(
                f"{implementation} assembly file not found: "
                f"{asm_file.resolve()}"
            )

    # Create test_cases directory
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    # Read all original assembly files once
    original_assemblies = {
        implementation: asm_file.read_text()
        for implementation, asm_file in BASE_ASM_FILES.items()
    }

    # Generate test cases
    for test_number in range(NUMBER_OF_TESTS):

        seed = 1000 + test_number

        # Generate one common input for all implementations
        samples = generate_samples(seed)

        # Generate all three assembly variants
        for implementation, original_assembly in original_assemblies.items():

            updated_assembly = replace_fft_input(
                original_assembly,
                samples
            )

            output_path = (
                OUTPUT_DIR /
                f"fft_{implementation}_test_{test_number:02d}.s"
            )

            output_path.write_text(updated_assembly)

        # Save common input JSON
        json_path = (
            OUTPUT_DIR /
            f"fft_test_{test_number:02d}_input.json"
        )

        save_packed_json(samples, json_path)

        print(f"\nGenerated test {test_number:02d}")
        print(f"  Seed: {seed}")

        for implementation in BASE_ASM_FILES:
            print(
                f"  {implementation}: "
                f"fft_{implementation}_test_{test_number:02d}.s"
            )

        print(f"  Input: {json_path.name}")

    print("\n--------------------------------------")
    print(f"Generated {NUMBER_OF_TESTS} test cases.")
    print(f"Assembly files: {NUMBER_OF_TESTS * len(BASE_ASM_FILES)}")
    print(f"Input JSON files: {NUMBER_OF_TESTS}")
    print(f"Output directory: {OUTPUT_DIR}")
    print("--------------------------------------")


if __name__ == "__main__":
    main()
