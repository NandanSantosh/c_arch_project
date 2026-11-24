# FFT on Kites: how to run

How to build `kites-cli`, run the FFT programs, and check the instruction counts and the output in memory.
Run every command from the **repo root**.

## 0. Python setup

You need Python 3.8 or newer. The only package outside the standard library is `numpy`.

```bash
python3 -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

| Script | Purpose |
|---|---|
| `fft_guide/check_fft.py` | accuracy of one memory dump: error vs numpy, optionally vs scalar or a golden dump |
| `fft_guide/summary.py` | instruction counts and weighted latency from the CSVs |
| `fft_guide/run_all.sh` | runs all programs, then both scripts above |
| `scripts/generate_inputs.py` | writes random-input test programs into `test_cases/` |
| `scripts/run_tests.py` | runs every test on `kites-cli` and checks each output |
| `scripts/outputs_comparision.py` | compares a scalar dump with a vector dump |
| `scripts/fft_compare.py` | latency tables (used by `summary.py`) |

## 1. Build

Apply the lexer fix first. Without it, every `.float` literal is rounded to 6 decimal places, which costs precision and makes the 256- and 1024-point tests fail.

```bash
git apply lexer_float_fix.patch
cmake -B build -DCMAKE_PREFIX_PATH="path/to/Qt/6.x.x/<compiler>" .
cmake --build build --target kites_cli      # -> build/kites-cli
```

## 2. Custom vector instructions

Vector registers `v0`–`v31` are 64 bits wide.

| Instruction | fp32 (2 lanes = 1 complex) | fp16 (`.h`, 4 lanes = 2 complex) |
|---|---|---|
| `vld vd, off(rs)` / `vsd vs, off(rs)` | load / store 64 bits | same |
| `vadd` / `vsub` | `(a+c, b+d)` / `(a-c, b-d)` | `vadd.h` / `vsub.h`, applied to all 4 lanes |
| `vmul` | `(a*c, b*d)` | `vmul.h` |
| `vcmpl vd, vs1, vs2` | `(ac-bd, ad+bc)`, complex multiply | `vcmpl.h`: two complex multiplies |
| `vconj vd, vs` | `a+bi -> a-bi` | — |
| `vmulj vd, vs` | `a+bi -> -b+ai` (multiply by `+i`) | — |
| `vswap vd, vs` | `(a, b) -> (b, a)` | — |

The fp16 complex multiply is spelled `vcmpl.h`; Kites rejects other spellings such as `vcompl.h`.

Memory layout of one complex sample:
- **fp32:** 8 bytes, real part in the low 32 bits.
- **fp16:** one 32-bit word, `(imag << 16) | real`.

## 3. Programs (`assembly_codes/`)

| File | Version |
|---|---|
| `N_p.s` | scalar fp32 (baseline) |
| `N_cmpl_conj_mulj.s` | vector fp32: `vcmpl` + `vconj` + `vmulj` |
| `N_fp16.s` | vector fp16: `vadd.h` / `vsub.h` / `vcmpl.h` |

`N` is 16, 64, 256 or 1024. All programs write the result over `x[]`, which starts at `0x10000000`.

## 4. Run one program

```bash
./build/kites-cli assembly_codes/16_p.s -o 16_p.csv \
    --mem-dump 0x10000000 16 --mem-output out/16_p.json
```

| Flag | Meaning |
|---|---|
| `-o NAME.csv` | instruction counts, saved as **`instructions_count/NAME.csv`** |
| `--mem-dump ADDR ROWS` | dump `ROWS` rows of 8 bytes starting at `ADDR` (`ROWS` is in decimal) |
| `--mem-output FILE` | where to write the memory dump JSON |
| `--vm rvss` | single-cycle processor (the default; needed for F and vector) |

> ⚠️ `-o` already puts the file inside `instructions_count/`.
> If you write `-o instructions_count/16_p.csv`, the CLI tries to write `instructions_count/instructions_count/16_p.csv`.
> That folder doesn't exist, so the CSV is silently not written. Pass the bare filename.

**How many rows to dump:** fp32 needs `ROWS = N` (8 bytes per sample). fp16 needs `ROWS = N/2` (4 bytes per sample).

## 5. Check the output against numpy

```bash
python3 fft_guide/check_fft.py assembly_codes/16_p.s out/16_p.json
python3 fft_guide/check_fft.py assembly_codes/16_fp16.s out/16_fp16.json --scalar out/16_p.json
python3 fft_guide/check_fft.py assembly_codes/16_p.s out/16_p.json --golden other.json
```

The script reads the input `x[]` from the `.s` file, so random inputs work too.

| Line | Reference |
|---|---|
| `[vs numpy f64]` | float64 FFT of the same input: the true error |
| `[vs scalar]` (with `--scalar`) | your scalar fp32 output: how far the vector version drifts from the baseline |
| `bit-exact` (with `--golden`) | another dump: how many samples match exactly |

Each line reports the largest absolute error, the relative L2 error, SNR and PSNR.

## 6. Compare instruction counts and weighted latency

```bash
python3 fft_guide/summary.py instructions_count/256_p.csv \
    instructions_count/256_cmpl_conj_mulj.csv instructions_count/256_fp16.csv
```

```
program               instrs  vector  ld/st  speedup     Optimistic        Moderate    Conservative
1024_p                213845       0  46994    1.00x  525095 (1.00x)  525095 (1.00x)  525095 (1.00x)
1024_cmpl_conj_mulj    72117   40228  24711    2.97x  158970 (3.30x)  187172 (2.81x)  245362 (2.14x)
1024_fp16              53313   19968  18624    4.01x   87841 (5.98x)   97569 (5.38x)  122145 (4.30x)
```

- **Put the scalar CSV first:** every speedup is relative to the first file.
- **`speedup`** compares raw instruction counts.
- **Scenario columns** give the weighted cost, $\sum$ count × latency, with the speedup over the first file in parentheses.
- **Latency tables** are imported from `scripts/fft_compare.py`, so you edit latencies in that one file.
- **Unknown instructions:** if a mnemonic has no latency, the script stops and names it.
- **`.h` instructions** use the same latency as their fp32 versions. This assumes the fp16 lanes run in parallel.

## 7. Run everything

```bash
bash fft_guide/run_all.sh            # N = 16 64 256 1024
bash fft_guide/run_all.sh 64         # a single size
```

This runs all 3 versions for each size and writes `instructions_count/N_*.csv` and `out/N_*.json`.
For each run it prints the error against numpy; the vector versions are also compared against the scalar output.
It then prints one table per size with instruction counts and weighted cost for all 3 latency scenarios, each with its speedup over scalar.

## 8. Test with random inputs

```bash
python3 scripts/generate_inputs.py --sizes 16 64 256 1024 --tests 10   # make test programs
python3 scripts/run_tests.py                                           # run + check all
python3 scripts/run_tests.py --sizes 64 --kites build/Debug/kites-cli.exe   # other build path
python3 scripts/outputs_comparision.py out/tests/256/fft_p_test_00.json \
                                       out/tests/256/fft_fp16_test_00.json   # one pair
```

- **`generate_inputs.py`** writes the same random input, uniform in $[-1,1]$, into all 3 versions.
  - Output: `test_cases/N/fft_{kind}_test_XX.s` and `fft_test_XX_input.json`.
  - fp32 versions get `.float` lines; the fp16 version gets packed `.word` lines.
- **`run_tests.py`** runs every test on `kites-cli` and prints one row per test, with min and mean rows per size.
  - **Reference:** `np.fft.fft` in float64 of the input read from each test's `.s` file. Its own error is about $10^{-16}$, so it serves as the exact answer.
  - **SNR vs numpy** for each version.
  - **SNR vs scalar** for the two vector versions.
  - **Bit-exact count** for vector fp32 against scalar (`exact32`). A low count is normal: scalar and vector compute the twiddles in a different order, so most bins differ by a few ULPs. An infinite SNR is printed as `exact`.
  - A test fails if fp32 is below 100 dB or fp16 is below 50 dB vs numpy, or a vector version differs from scalar by more than the `outputs_comparision.py` tolerance. Any failure makes the script exit with code 1.
- **`outputs_comparision.py`** compares two dumps: scalar against vector fp32, or scalar against fp16 (detected automatically).
  - Bit-exact equality isn't expected, because scalar and vector round in a different order.
  - It passes if the relative L2 difference is at most `--tol` (default $10^{-5}$ for fp32, $5\times10^{-3}$ for fp16).

Typical results with random inputs (mean SNR vs numpy):

| N | scalar | vector fp32 | vector fp16 |
|---|---|---|---|
| 16 | 139 dB | 140 dB | 66 dB |
| 64 | 128 dB | 128 dB | 64 dB |
| 256 | 124 dB | 123 dB | 62 dB |
| 1024 | 113 dB | 110 dB | 61 dB |

`test_cases/` doesn't need to be kept: `generate_inputs.py` recreates it. The default `--seed 1000` gives the same inputs every time.

## 9. Troubleshooting

| Symptom | Cause / fix |
|---|---|
| `ModuleNotFoundError: numpy` | `pip install -r requirements.txt` |
| `kites-cli not found` | build it, or pass `--kites PATH` |
| `Assembly failed: Failed to parse file` | unsupported mnemonic, e.g. `vcompl.h` instead of `vcmpl.h` |
| vec32 SNR near 0 dB | len-4 stage assumes the wrong sign for `vmulj` (`vmulj` multiplies by `+i`) |
| scalar and vec32 SNR fall steadily as N grows | `lexer_float_fix.patch` not applied |
| CSV missing after `-o instructions_count/x.csv` | pass only the file name: `-o x.csv` |

## Reference results (input: re = 1..16, im = 0.1..0.7)

| N | Version | Instructions | SNR |
|---|---|---|---|
| 256 | scalar fp32 | 44,204 | 135 dB |
| 256 | vector fp32 | 15,474 | 129 dB |
| 256 | vector fp16 | 11,978 | 75 dB |
| 1024 | scalar fp32 | 213,842 | 120 dB |
| 1024 | vector fp32 | 72,114 | 118 dB |
| 1024 | vector fp16 | 53,310 | 76 dB |

These counts come from a Python model of the instruction set, not from Kites. Kites expands pseudo-instructions such as `la` into two real instructions, so its totals will be a little higher.
