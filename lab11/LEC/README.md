# Lab: Synthesis (Genus) + Logic Equivalence Check (Conformal LEC) — 90nm

Design: `design\\\\\\\_top` — 9-bit registered unit
`sel=1 : y <= (a+b) ^ c`  `sel=0 : y <= (a-b) + c`, async active-low reset.

|Case|Golden|Revised|Expected result|
|-|-|-|-|
|PASS|`RTL/design.v`|netlist from `design.v`|All points **Equivalent**|
|FAIL|`RTL/design.v`|netlist from `design\\\\\\\_faulty.v` (`^` replaced by `\|`)|`y\\\\\\\_reg\\\\\\\[0..7]` **Non-equivalent**, `y\\\\\\\_reg\\\\\\\[8]` equivalent|

## Folder layout

```
Cadence\\\\\\\_90nm\\\\\\\_LEC\\\\\\\_Updated/
├── RTL/          design.v (golden), design\\\\\\\_faulty.v (bug)
├── Constraints/  constraints\\\\\\\_top.sdc
├── LIB/          put your 90nm .lib here (or point the scripts to it)
├── synthesis/    synthesis.tcl, synthesis\\\\\\\_faulty.tcl, reports/, outputs/
├── LEC/          lib\\\\\\\_convert.do, lec\\\\\\\_pass.do, lec\\\\\\\_fail.do
├── logs/         all tool logs land here
└── run.sh        optional one-shot runner
```

## Step 0 — Edit paths (once per system)

Every script has an **EDIT PATHS HERE** block at the top.

* `synthesis/synthesis.tcl` and `synthesis/synthesis\\\\\\\_faulty.tcl` → `LIB\\\\\\\_DIR`, `LIB\\\\\\\_NAME`
* `LEC/lib\\\\\\\_convert.do` → `read library <your .lib>` line
* `LEC/lec\\\\\\\_pass.do`, `LEC/lec\\\\\\\_fail.do` → `read library` line

Two easy options:

1. Copy your 90nm library into `LIB/` as `slow.lib` → **no edits needed**.
2. Or put full paths in the scripts, e.g. `/home/install/FOUNDRY/digital/90nm/dig/lib/slow.lib`
(`slow.lib` is the usual name in the Cadence 90nm gsclib; use `typical.lib`/`fast.lib` if your lab says so).

Source the Cadence setup (`source \\\\\\\~/cshrc` or your lab's setup file) so that `genus` and `lec` are on PATH.

## Step 1 — Synthesis (golden RTL → PASS netlist)

```
cd synthesis
genus -files synthesis.tcl -log ../logs/genus\\\\\\\_pass
```

Check: `logs/genus\\\\\\\_pass.log` has no errors, `check\\\\\\\_design` shows no unresolved references,
`outputs/design\\\\\\\_netlist.v` exists, reports in `reports/`.

## Step 2 — Synthesis (faulty RTL → FAIL netlist)

```
genus -files synthesis\\\\\\\_faulty.tcl -log ../logs/genus\\\\\\\_fail
cd ..
```

Creates `synthesis/outputs/design\\\\\\\_netlist\\\\\\\_faulty.v`.

## Step 3 — Convert the library for LEC

```
cd LEC
lec -XL -nogui -color -64 -dofile lib\\\\\\\_convert.do
```

Creates `LIB/slow.v`. *(Skip this step if you switch `lec\\\\\\\_\\\\\\\*.do` to the commented
`read library ... -liberty -both` line.)*

## Step 4 — LEC PASS case

```
lec -XL -nogui -dofile lec\\\\\\\_pass.do
```

In `logs/lec\\\\\\\_pass.log`, the compare summary should show every point **Equivalent**,
**Non-equivalent = 0**, and no unmapped points apart from expected ones.

## Step 5 — LEC FAIL case

```
lec -XL -nogui -dofile lec\\\\\\\_fail.do
cd ..
```

In `logs/lec\\\\\\\_fail.log`: **Non-equivalent = 8** (`y\\\\\\\_reg\\\\\\\[0]..y\\\\\\\_reg\\\\\\\[7]`); `y\\\\\\\_reg\\\\\\\[8]` is still
Equivalent because bit 8 of `{1'b0,c}` is 0 and `x^0 == x|0`.

To look at a failing point in the GUI, run without `-nogui` and drop `exit -force`, then use
**Debug → Diagnose** on a non-equivalent point to see the counter-example (e.g. `sel=1`, `a+b` and `c` both 1 in the same bit).

## One-shot alternative

```
chmod +x run.sh
./run.sh all        # synth -> lib -> pass -> fail -> summary
./run.sh clean      # remove generated files
```

## 

