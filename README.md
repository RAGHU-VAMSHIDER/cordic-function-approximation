# CORDIC — Verilog + MATLAB (informal)

Hey — this repo is my CORDIC design playground: a Verilog implementation of a CORDIC module plus MATLAB stuff to generate golden results and cross-check the RTL. The goal: design the core in Verilog, simulate it, and verify correctness & numerical accuracy against MATLAB outputs.

This README is intentionally informal — quick, to the point, and focused on getting you running.

What’s in this repo (top-level)
- README.md (this file)
- matlab generated files/        — MATLAB output (CSV/MAT, plots) (note: has spaces)
- matlab source/                 — MATLAB scripts (vector/golden generation, analysis)
- simulation source/             — testbench, sim runner scripts
- simulation_outputs/            — where sim stuff ends up (CSV, waveforms)
- verilog desigen sorces/        — Verilog RTL (typo present in dir name)

Quick notes about the repo layout
- Directories have spaces and a typo: `verilog desigen sorces` and `matlab generated files`. It works, but it’s annoying when scripting. Consider renaming them to `verilog_design_sources` and `matlab_generated_files` later.

Quick start (the short route)
Prereqs:
- MATLAB (or Octave if you tweak scripts)
- Icarus Verilog (iverilog + vvp) or ModelSim/Questa
- Python3 (optional, for comparison scripts)
- gtkwave (optional)

1) Generate golden vectors in MATLAB
- Open MATLAB and run the generator in `matlab source/` (file name may vary).
- Example (replace script name with the real one in the folder):
  matlab -batch "run('matlab source/gen_vectors.m')"
- This should drop CSV/MAT golden files into `matlab generated files/`.

2) Run the Verilog sim
- Compile + run the TB (adjust file names to match repo contents):
  mkdir -p simulation_outputs
  iverilog -g2005 -o simulation_outputs/tb.vvp "verilog desigen sorces/cordic.v" "simulation source/tb_cordic.v"
  vvp simulation_outputs/tb.vvp
- The TB should read the MATLAB CSV and write RTL results to `simulation_outputs/rtl_results.csv`.

3) Compare results (MATLAB or Python)
- Either run a Python script in `simulation source/` that compares CSVs, or use a MATLAB analysis script.
- Example (python compare script):
  python3 "simulation source/compare_results.py" --gold "matlab generated files/golden_results.csv" --rtl "simulation_outputs/rtl_results.csv" --out "simulation_outputs/compare_report.json"
- Or in MATLAB:
  matlab -batch "run('matlab source/analyze_results.m')"

What to check when things don’t match
- Q-format mismatch: Make sure MATLAB quantizes to the same fixed-point format (Qm.n) the RTL uses.
- Scaling / CORDIC gain: rotation-mode outputs usually need 1/K compensation — confirm both models do the same.
- Angle normalization: confirm both models use the same angle domain/wrap rules ([-pi, pi], [-pi/2, pi/2], etc.).
- File paths: spaces in folder names can break TB scripts; run simulator from repo root or update TB file paths.

Suggested acceptance criteria (simple)
- Max abs error below your target (e.g., < 2^-14 for a 16-bit design)
- RMSE small and consistent with chosen iterations and bitwidth
- No crashes or obvious misbehavior at edge inputs (0, ±π/2, ±π, ±2π)

Tips & small improvements you can add
- Rename directories to remove spaces and fix typos.
- Add a top-level run_all.sh or Makefile to:
  1) run MATLAB vector gen
  2) compile & run Verilog sim
  3) run the comparison script
  This makes demos and CI way easier.
- Add a short example showing one angle fed through MATLAB and RTL and printed side-by-side.
- Add a LICENSE and short CONTRIBUTING.md if you want PRs.

A short troubleshooting checklist
- Does the TB read the CSV you just created? (check path / delimiter / column order)
- Is MATLAB using the same fixed-point bits and scaling as RTL?
- Did you forget the CORDIC K gain compensation?
- If using ModelSim, run the .do to open waveforms and inspect signals.

If you want, I can:
- List all files inside each directory and then rewrite this README to reference exact filenames and commands.
- Add a runnable run_all.sh that uses the actual filenames present in the repo (I’ll need to list files first).
- Make the tone even more casual or more formal — your call.

Which one next? Want me to list files in `verilog desigen sorces`, `matlab source`, and `simulation source` so I can produce an exact runnable README and a helper script?
