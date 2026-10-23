# RTL Synthesis & QoR Analysis — 4-bit RCA and 4-bit Sequential ALU
### Cadence Genus Synthesis Assignment

This package contains everything you need to synthesize both designs in
Cadence Genus, generate Generic / Mapped / Optimized reports, and fill in
the comparison tables required by the assignment.

---

## 1. Folder structure (what's in the zip)

```
rtl_synthesis_project/
├── README.md                              <- this file
│
├── rca_4bit/                               DESIGN (a): 4-bit Ripple Carry Adder
│   ├── rtl/
│   │   ├── full_adder.v                    1-bit full adder (gate-level)
│   │   ├── rca_4bit.v                      4-bit RCA top (structural)
│   │   └── tb_rca_4bit.v                   optional testbench (pre-synth check)
│   ├── constraints/
│   │   └── rca_constraints.sdc             virtual clock + I/O delay/xn/load
│   ├── scripts/
│   │   └── run_synthesis.tcl               Genus script: Generic->Mapped->Opt
│   ├── reports/
│   │   ├── generic/                        (populated after you run Genus)
│   │   ├── mapped/                         (populated after you run Genus)
│   │   └── optimized/                      (populated after you run Genus)
│   ├── outputs/                            synthesized netlists (.v) + .sdc
│   └── logs/                               Genus log file goes here
│
├── alu_4bit/                               DESIGN (b): 4-bit Sequential ALU
│   ├── rtl/
│   │   ├── alu_4bit_seq.v                  sequential ALU RTL
│   │   └── tb_alu_4bit_seq.v               optional testbench (pre-synth check)
│   ├── constraints/
│   │   └── alu_constraints.sdc             real clock + I/O delay/xn/load
│   ├── scripts/
│   │   └── run_synthesis.tcl               Genus script: Generic->Mapped->Opt
│   ├── reports/{generic,mapped,optimized}/ (populated after you run Genus)
│   ├── outputs/                            synthesized netlists (.v) + .sdc
│   └── logs/
│
└── comparison_templates/
    ├── rca_comparison_template.csv         fill this in from the reports
    └── alu_comparison_template.csv         fill this in from the reports
```

---

## 2. Prerequisites

- Access to **Cadence Genus** (via your university/lab server, VM, or
  license).
- A **technology library** (`.lib`) — whatever your course provides
  (e.g. a generic 45nm/32nm educational kit such as `gscl45nm`,
  `saed32`, `NanGate45`, etc.). You must know the path to it.
- Basic familiarity with a Linux shell, since Genus is invoked from the
  command line (`genus -f script.tcl`).

---

## 3. ONE-TIME SETUP — point the scripts at your library

Open **both** of these files:
- `rca_4bit/scripts/run_synthesis.tcl`
- `alu_4bit/scripts/run_synthesis.tcl`

At the top, edit:

```tcl
set_db init_lib_search_path { /path/to/your/tech/lib }
set_db library { your_tech_lib.lib }
```

Replace with your actual library path and `.lib` filename, e.g.:

```tcl
set_db init_lib_search_path { /home/students/labkit/gscl45nm/lib }
set_db library { gscl45nm.lib }
```

That is the only mandatory edit — RTL and SDC constraints are already
written for you and require no changes.

---

## 4. STEP-BY-STEP EXECUTION (cut-to-cut)

### A) 4-bit Ripple Carry Adder

```bash
# 1. Unzip the package and move into it
unzip rtl_synthesis_project.zip
cd rtl_synthesis_project/rca_4bit

# 2. (Optional) Functional sanity check in any simulator, e.g. iverilog:
iverilog -o rca_sim rtl/full_adder.v rtl/rca_4bit.v rtl/tb_rca_4bit.v
vvp rca_sim
# Confirms Sum/Cout are functionally correct BEFORE you spend synthesis time.

# 3. Launch Genus and run the synthesis script
genus -f scripts/run_synthesis.tcl -log logs/rca_synth.log

# 4. Watch the terminal / log for elaboration and mapping errors.
#    On success you will see:
#    "RCA 4-bit synthesis COMPLETE."

# 5. Check outputs:
ls reports/generic/     # timing_generic.rpt, area_generic.rpt, power_generic.rpt, ...
ls reports/mapped/
ls reports/optimized/
ls outputs/             # rca_4bit_generic.v, rca_4bit_mapped.v, rca_4bit_optimized.v
```

### B) 4-bit Sequential ALU

```bash
cd ../alu_4bit

# 1. (Optional) Functional sanity check
iverilog -o alu_sim rtl/alu_4bit_seq.v rtl/tb_alu_4bit_seq.v
vvp alu_sim

# 2. Launch Genus and run the synthesis script
genus -f scripts/run_synthesis.tcl -log logs/alu_synth.log

# 3. Check outputs:
ls reports/generic/
ls reports/mapped/
ls reports/optimized/
ls outputs/
```

### What `run_synthesis.tcl` does internally, stage by stage

| Stage | Genus command | What happens |
|---|---|---|
| Read design | `read_hdl`, `elaborate` | Parses Verilog into an internal generic netlist |
| Constrain | `read_sdc` | Applies clock, input/output delay, transition, load |
| **Generic**   | `syn_generic` | Maps RTL to technology-independent generic gates (GTECH). First cut at logic structure, no real cell timing yet. |
| **Mapped**    | `syn_map`     | Maps generic gates to actual standard cells from your `.lib`. Real area/timing/power numbers appear here. |
| **Optimized** | `syn_opt`     | Runs timing/area/power-driven optimization (buffering, resizing, restructuring) on the mapped netlist to close any timing violations and improve QoR. |

After **each** stage the script automatically writes:
- `report_timing` → setup/hold slack, critical path
- `report_area` → cell count, combinational/sequential area
- `report_power` → leakage, dynamic/switching, total power
- `report_gates` → gate/instance breakdown
- `report_qor` → Genus's built-in Quality-of-Results summary
- a synthesized netlist (`write_hdl`) and constraints (`write_sdc`)

---

## 5. Filling in the comparison tables

Open `comparison_templates/rca_comparison_template.csv` and
`alu_comparison_template.csv` (Excel/Google Sheets/LibreOffice) and copy
the relevant numbers from:

- `reports/generic/*.rpt`   → "Generic" column
- `reports/mapped/*.rpt`    → "Mapped" column
- `reports/optimized/*.rpt` → "Optimized" column

Typical values to pull:
- From `timing_*.rpt`: **Worst Negative Slack (WNS)**, **Total Negative
  Slack (TNS)**, critical path delay, number of violating paths.
- From `area_*.rpt`: total cell area, combinational vs. sequential
  (noncombinational) area, cell count.
- From `power_*.rpt`: leakage power, internal/switching power, total
  power.
- From `qor_*.rpt`: Genus's summarized QoR numbers (often mirrors the
  above plus runtime).

Use the "Observation/Notes" column to comment on the trend you should
generally expect:
- **Generic → Mapped**: area/power become "real" (tied to actual std
  cells); timing may initially look worse or unresolved because no
  optimization has run yet.
- **Mapped → Optimized**: timing violations should reduce/disappear
  (WNS/TNS improve or hit 0), area typically increases slightly
  (buffers/resizing added to fix timing), and power may shift
  accordingly.

---

## 6. Deliverables — what to submit

| # | File / Report | Purpose |
|---|---|---|
| 1 | `rca_4bit/rtl/*.v` | Source RTL for the RCA (structural) |
| 2 | `alu_4bit/rtl/*.v` | Source RTL for the sequential ALU |
| 3 | `rca_4bit/constraints/rca_constraints.sdc` | Constraints used (virtual clock) |
| 4 | `alu_4bit/constraints/alu_constraints.sdc` | Constraints used (real clock) |
| 5 | `rca_4bit/scripts/run_synthesis.tcl` | Genus synthesis script (RCA) |
| 6 | `alu_4bit/scripts/run_synthesis.tcl` | Genus synthesis script (ALU) |
| 7 | `rca_4bit/reports/{generic,mapped,optimized}/*.rpt` | Generated Timing/Area/Power/QoR reports (RCA) |
| 8 | `alu_4bit/reports/{generic,mapped,optimized}/*.rpt` | Generated Timing/Area/Power/QoR reports (ALU) |
| 9 | `rca_4bit/outputs/*.v`, `alu_4bit/outputs/*.v` | Synthesized gate-level netlists at each stage |
| 10 | `comparison_templates/*_comparison_template.csv` (filled in) | Your Generic vs Mapped vs Optimized comparison tables |
| 11 | `rca_4bit/logs/*.log`, `alu_4bit/logs/*.log` | Genus run logs (proof of successful execution, useful for debugging) |
| 12 | A short write-up (Word/PDF) summarizing the comparison + your analysis | Final report to submit alongside the above |

**Files 1–6 are provided in this zip already (inputs you author/use).**
**Files 7–9, 11 are GENERATED by you when you run Genus (outputs).**
**Files 10, 12 you fill in / write after reviewing the generated reports.**

---

## 7. Troubleshooting tips

- **"Cannot find library" error** → double-check `init_lib_search_path`
  and `library` in the `.tcl` script match your actual `.lib` file name
  and location exactly.
- **Elaboration error on `rca_4bit`** → make sure both `full_adder.v`
  AND `rca_4bit.v` are listed in the same `read_hdl { ... }` call (the
  script already does this — don't split them into separate calls).
- **No timing violations show up in Generic stage** → expected; Genus
  hasn't mapped to real cells yet, so timing numbers there are only
  indicative. Real analysis starts at the Mapped stage.
- **Virtual clock warning ("clock not found on any port")** → this is
  expected and harmless for the RCA; a virtual clock intentionally has
  no physical port.
- **`set_false_path -from [get_ports rst_n]` too aggressive** → if your
  course wants reset timing analyzed instead of excluded, delete that
  line in `alu_constraints.sdc` and uncomment the reset `set_input_delay`
  line at the bottom of that file instead.

---

## 8. Quick command reference

```bash
# Full run, both designs
cd rca_4bit  && genus -f scripts/run_synthesis.tcl -log logs/rca_synth.log && cd ..
cd alu_4bit  && genus -f scripts/run_synthesis.tcl -log logs/alu_synth.log && cd ..

# Interactive Genus session (if you want to run stage-by-stage manually
# instead of the batch script) - useful for debugging:
genus -legacy_ui
Genus> read_hdl { rtl/full_adder.v rtl/rca_4bit.v }
Genus> elaborate rca_4bit
Genus> read_sdc constraints/rca_constraints.sdc
Genus> syn_generic
Genus> report_timing
Genus> syn_map
Genus> report_timing
Genus> syn_opt
Genus> report_timing
Genus> exit
```

Good luck — and remember the report/analysis narrative (Section 5) is
usually worth as much credit as getting the numbers themselves.
