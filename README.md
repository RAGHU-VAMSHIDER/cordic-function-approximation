
# CORDIC — Verilog Design, MATLAB Cross‑Check, and Verification Flow

This repository contains a Verilog CORDIC design together with MATLAB-based golden-model generation and simulation artifacts for cross-checking the RTL results. The project is focused on the design and verification of a CORDIC module in Verilog and validating its functional correctness and numerical accuracy by cross-checking outputs against MATLAB reference results.

Quick summary
- RTL design in Verilog (synthesizable CORDIC core)
- MATLAB scripts to generate golden outputs and analyze errors
- Simulation sources and outputs to compare RTL vs MATLAB
- Automation scripts to run simulation and perform comparisons

Repository layout (as found at the top level)
- README.md (this file)
- matlab generated files/        — directory containing MATLAB-produced CSV/MAT outputs (golden vectors, plots, etc.)
- matlab source/                 — MATLAB sources (vector generation, analysis, plotting)
- simulation source/             — testbench, simulation harness, runner scripts
- simulation_outputs/            — produced simulation outputs (CSV, VCD, traces)
- verilog desigen sorces/        — Verilog RTL sources (note: directory name contains a typo)

Note about directory names
- I found the repository contains these directories and their names exactly as listed above. I recommend renaming `verilog desigen sorces` → `verilog_design_sources` (or `rtl/`) and `matlab generated files` → `matlab_generated_files` for consistency and easier scripting. This is optional but will reduce issues when writing scripts that assume no spaces or typos in paths.

What you should expect inside each directory
- matlab source/
  - Scripts to generate input vectors and golden reference outputs (CSV/MAT).
  - Analysis scripts that compute error metrics (max abs error, RMSE) and produce plots comparing RTL vs MATLAB.
- matlab generated files/
  - CSV/MAT files with golden reference results produced by MATLAB (e.g., `golden_results.csv`, `test_vectors.csv`).
  - Optional plots or data used by the simulation flow.
- verilog desigen sorces/
  - The synthesizable CORDIC RTL (core module(s)) and parameter/header files that set Q-formats and iteration count.
- simulation source/
  - Verilog testbench(s) that read test vectors (CSV), drive the DUT, and write out RTL results.
  - Simulation runner scripts (e.g., for iverilog/vvp or ModelSim/Questa).
- simulation_outputs/
  - Output CSVs from the RTL simulation, VCD/FSDB waveform files, and compare reports.

Quick start (generic — adapt to exact filenames in your repo)

Prerequisites
- MATLAB (or Octave; some scripts may require MATLAB toolboxes)
- Icarus Verilog (iverilog + vvp) or ModelSim/Questa for RTL simulation
- Python 3 (optional; for comparison scripts)
- gtkwave (optional; for waveform viewing)

1) Generate MATLAB golden vectors and references
- Open MATLAB and run the generation script (replace `gen_vectors.m` with actual script name in `matlab source/`):
  matlab -batch "run('matlab source/gen_vectors.m')"
- Expected output: CSV/MAT files in `matlab generated files/` (e.g., `test_vectors.csv`, `golden_results.csv`).

2) Run Verilog simulation
- Ensure the testbench reads the MATLAB-produced input file(s).
- Example using iverilog (adjust filenames to match the repo):
  mkdir -p simulation_outputs
  iverilog -g2005 -o simulation_outputs/tb.vvp \
    "verilog desigen sorces/cordic.v" "simulation source/tb_cordic.v"
  vvp simulation_outputs/tb.vvp
- The testbench should create an RTL results CSV inside `simulation_outputs/`.

3) Compare RTL outputs to MATLAB golden references
- Use a comparison script (MATLAB or Python) to compute errors:
  python3 simulation source/compare_results.py \
    --gold "matlab generated files/golden_results.csv" \
    --rtl "simulation_outputs/rtl_results.csv" \
    --out "simulation_outputs/compare_report.json"
- Or run MATLAB analyze script:
  matlab -batch "run('matlab source/analyze_results.m')"

Verification flow & acceptance criteria
- Generate comprehensive vectors: uniform sweep across angle domain, edge cases (0, ±π/2, ±π, ±2π), and random vectors.
- Ensure Q-format agreement: The MATLAB golden must be quantized to the same fixed-point representation used by the RTL before comparison.
- Acceptance metrics:
  - Max absolute error less than a target (e.g., < 2^-14 for a 16-bit Q-format).
  - RMSE within expected bounds determined by iteration count and word width.
  - No functional mismatches for edge inputs (wrap/normalization working correctly).

Common pitfalls and checks
- Mismatched Q-format / scaling: Confirm the MATLAB script and RTL use the same integer/fraction bits and gain compensation. Rotation mode outputs usually require CORDIC gain compensation (multiply by 1/K or integrate compensation into iterations).
- Angle normalization: Ensure both models normalize angles the same way (e.g., wrap to [-π/2, π/2] or [-π, π]).
- CSV format and file paths: Testbench path must match where MATLAB writes vectors; avoid spaces in filenames (current repo uses spaces in directory names).
- Simulation working directory: Some TBs use relative paths — run the simulator from the repository root or update paths in the TB.

Suggested next improvements (actionable)
- Remove spaces and fix typos in directory names to avoid quoting issues in scripts.
- Add a short `run_all.sh` or Makefile at the repo root that:
  - Runs MATLAB vector generation
  - Compiles & runs the RTL simulation
  - Runs the comparison script and saves a report
- Add a small example that demonstrates running one vector through RTL and MATLAB and shows the numerical difference.
- Add a LICENSE file and a contributor guide if you plan to accept PRs.

Contact / author
- Repository owner: RAGHU-VAMSHIDER (use GitHub for issues / PRs)

License
- Please add or confirm a license in the repository root (MIT suggested for academic/demo code).

---

If you’d like, I can now:
- Inspect the contents of each directory (list all files under each) and update this README with exact filenames, commands and tailored examples that reference the real scripts and modules in the repository.
- Or I can create a small `run_all.sh` that wires the MATLAB generation, iverilog compilation, and comparison steps together (I will need to read the exact filenames first).

Which of these should I do next? I can start by listing the files inside `verilog desigen sorces`, `matlab source`, and `simulation source` so I can produce an exact, ready-to-run README and helper scripts.
