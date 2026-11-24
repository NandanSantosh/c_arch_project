#!/usr/bin/env python3
"""
Compare Kites scalar and vector FFT memory dumps.

Usage:
    python compare_fft.py scalar_memory_dump.json vector_memory_dump.json

Each JSON entry maps a 64-bit memory address to a 64-bit hexadecimal word.
The word contains two packed FP32 lanes. The script compares the raw words
exactly and also reports decoded FP32 lane differences.
"""

import json
import struct
import sys
from pathlib import Path


def load_dump(filename):
    with open(filename, "r", encoding="utf-8") as f:
        data = json.load(f)

    if not isinstance(data, dict):
        raise ValueError(f"{filename}: expected a JSON object")

    result = {}
    for address, value in data.items():
        addr = int(address, 16)
        word = int(value, 16)
        if not 0 <= word < (1 << 64):
            raise ValueError(f"{filename}: value at {address} is not 64-bit")
        result[addr] = word
    return result


def fp32_from_bits(bits):
    return struct.unpack(">f", bits.to_bytes(4, byteorder="big"))[0]


def main():
    if len(sys.argv) != 3:
        print("Usage: python compare_fft.py scalar_memory_dump.json vector_memory_dump.json")
        raise SystemExit(2)

    scalar_file, vector_file = sys.argv[1], sys.argv[2]
    scalar = load_dump(scalar_file)
    vector = load_dump(vector_file)

    scalar_addresses = set(scalar)
    vector_addresses = set(vector)
    common = sorted(scalar_addresses & vector_addresses)
    scalar_only = sorted(scalar_addresses - vector_addresses)
    vector_only = sorted(vector_addresses - scalar_addresses)

    print("FFT memory dump comparison")
    print(f"Scalar file: {scalar_file}")
    print(f"Vector file: {vector_file}")
    print(f"Scalar entries: {len(scalar)}")
    print(f"Vector entries: {len(vector)}")
    print(f"Common addresses: {len(common)}")
    print(f"Addresses only in scalar: {len(scalar_only)}")
    print(f"Addresses only in vector: {len(vector_only)}")

    different_words = []
    lane_differences = []
    max_abs_error = 0.0

    for address in common:
        scalar_word = scalar[address]
        vector_word = vector[address]

        if scalar_word != vector_word:
            different_words.append((address, scalar_word, vector_word))

        # Each 64-bit word is two FP32 lanes: high 32 bits, then low 32 bits.
        scalar_lanes = (scalar_word >> 32, scalar_word & 0xFFFFFFFF)
        vector_lanes = (vector_word >> 32, vector_word & 0xFFFFFFFF)

        for lane_index, (sb, vb) in enumerate(zip(scalar_lanes, vector_lanes)):
            sf = fp32_from_bits(sb)
            vf = fp32_from_bits(vb)
            if sb != vb:
                lane_differences.append((address, lane_index, sf, vf))
                if sf == sf and vf == vf:  # ignore NaN when calculating error
                    max_abs_error = max(max_abs_error, abs(sf - vf))

    print(f"Different 64-bit words: {len(different_words)}")
    print(f"Different FP32 lanes: {len(lane_differences)}")

    if lane_differences:
        print(f"Maximum absolute FP32 error: {max_abs_error:.9g}")
        print("\nFirst differing values:")
        for address, lane, scalar_value, vector_value in lane_differences[:10]:
            lane_name = "high" if lane == 0 else "low"
            print(
                f"  address 0x{address:016x}, {lane_name} lane: "
                f"scalar={scalar_value:.9g}, vector={vector_value:.9g}"
            )

    exact_match = not scalar_only and not vector_only and not different_words
    print("\nRESULT:", "PASS - outputs are bit-for-bit identical"
          if exact_match else "DIFFERENT - inspect the mismatches")

    raise SystemExit(0 if exact_match else 1)


if __name__ == "__main__":
    main()
