#!/usr/bin/env bash
# Run every FFT program: instruction counts -> instructions_count/<name>.csv,
# memory dump of x[] -> out/<name>.json, then check against numpy.
# Run from the repo root:  bash fft_guide/run_all.sh [16 64 256 1024]
set -e
SIZES="${*:-16 64 256 1024}"
mkdir -p instructions_count out

for N in $SIZES; do
  for kind in p cmpl_conj_mulj fp16; do
    name="${N}_${kind}"
    asm="assembly_codes/${name}.s"
    [ -f "$asm" ] || { echo "skip $asm"; continue; }
    # one dump row = 8 bytes: fp32 sample = 8 B, fp16 sample = 4 B
    if [ "$kind" = fp16 ]; then rows=$((N / 2)); else rows=$N; fi
    echo "== $name"
    ./build/kites-cli "$asm" -o "${name}.csv" \
        --mem-dump 0x10000000 "$rows" --mem-output "out/${name}.json" > /dev/null
    if [ "$kind" = p ]; then
      python3 fft_guide/check_fft.py "$asm" "out/${name}.json" | tail -n +2
    else   # vector versions: also compare against the scalar output
      python3 fft_guide/check_fft.py "$asm" "out/${name}.json" \
          --scalar "out/${N}_p.json" | tail -n +2
    fi
  done
done

# one table per size: counts + weighted latency cost, speedup vs that size's scalar
for N in $SIZES; do
  echo; echo "== instruction counts + weighted latency, N = $N"
  python3 fft_guide/summary.py $(ls instructions_count/${N}_{p,cmpl_conj_mulj,fp16}.csv 2>/dev/null)
done
