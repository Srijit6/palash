ACTIVITY-BASED POWER ANALYSIS - EASY TCL VERSION
================================================

Folder structure
----------------
RTL/          : RTL design
TB/           : Four testbenches
LIB/          : Liberty library
constraints/  : SDC file
scripts/      : Simple Genus and simulation scripts
vcd/          : Generated VCD files
reports/      : Separate report folder for each analysis
outputs/      : Netlist and SDC outputs

Report folder structure
-----------------------
reports/
  synthesis/
  clk_low/
  clk_high/
  data_low/
  data_high/

Each analysis folder contains:
  report_timing.rpt
  report_power.rpt
  report_area.rpt
  report_qor.rpt

NOTE:
The write_sdf command has been removed from all TCL scripts.
No SDF file is generated in this version.

A. SYNTHESIS ONLY
-----------------
1. Open terminal in this project folder.
2. Enter:

   cd scripts
   genus -f synthesis_only.tcl

Generated reports:
   ../reports/synthesis/report_timing.rpt
   ../reports/synthesis/report_power.rpt
   ../reports/synthesis/report_area.rpt
   ../reports/synthesis/report_qor.rpt

Generated outputs:
   ../outputs/activity_power_top_netlist.v
   ../outputs/activity_power_top_sdc.sdc

B. ACTIVITY-BASED POWER ANALYSIS
--------------------------------
Step 1 - Generate VCD files with Xcelium:

   cd scripts
   ./run_sim_xrun.sh

Step 2 - Run one case, for example:

   genus -f power_clk_low.tcl

Other cases:
   genus -f power_clk_high.tcl
   genus -f power_data_low.tcl
   genus -f power_data_high.tcl

Or run all four:
   ./run_genus_all.sh

Reports are stored separately:

LOW CLOCK:
   ../reports/clk_low/report_timing.rpt
   ../reports/clk_low/report_power.rpt
   ../reports/clk_low/report_area.rpt
   ../reports/clk_low/report_qor.rpt

HIGH CLOCK:
   ../reports/clk_high/report_timing.rpt
   ../reports/clk_high/report_power.rpt
   ../reports/clk_high/report_area.rpt
   ../reports/clk_high/report_qor.rpt

LOW DATA:
   ../reports/data_low/report_timing.rpt
   ../reports/data_low/report_power.rpt
   ../reports/data_low/report_area.rpt
   ../reports/data_low/report_qor.rpt

HIGH DATA:
   ../reports/data_high/report_timing.rpt
   ../reports/data_high/report_power.rpt
   ../reports/data_high/report_area.rpt
   ../reports/data_high/report_qor.rpt

Important:
- Run the TCL files FROM THE scripts/ FOLDER because the paths use ../RTL, ../LIB, etc.
- The same SDC is used for all four cases; only the VCD switching activity changes.
- VCD scope used by each script matches the testbench instance: tb_<case>/dut.
