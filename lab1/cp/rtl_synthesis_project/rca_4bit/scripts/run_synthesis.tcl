# =====================================================================
# Cadence Genus Synthesis Script
# Design : 4-bit Ripple Carry Adder (rca_4bit)  - Combinational
# Flow   : Generic -> Mapped -> Optimized, with reports at every stage
#
# USAGE (from the rca_4bit/ directory):
#   genus -f scripts/run_synthesis.tcl -log logs/rca_synth.log
# =====================================================================

# ---------------------------------------------------------------
# 0. EDIT THIS SECTION: point to your technology library
# ---------------------------------------------------------------
# Example for a generic/academic library (gscl45nm, saed32, etc.)
# Replace the paths below with the .lib the lab/course provides.
set_db init_lib_search_path /home/install/FOUNDRY/digital/90nm/dig/lib
set_db library slow.lib

# Optional but recommended Genus global settings
set_db information_level 7
set_db hdl_error_on_blackbox true

# ---------------------------------------------------------------
# 1. READ RTL
# ---------------------------------------------------------------
read_hdl { ../rca_4bit/rtl/full_adder.v ../rca_4bit/rtl/rca_4bit.v }

# ---------------------------------------------------------------
# 2. ELABORATE
# ---------------------------------------------------------------
elaborate rca_4bit
current_design rca_4bit

# ---------------------------------------------------------------
# 3. READ SDC CONSTRAINTS (virtual clock, I/O delay, transition, load)
# ---------------------------------------------------------------
read_sdc ../rca_4bit/constraints/rca_constraints.sdc

# =====================================================================
# STAGE 1 : GENERIC SYNTHESIS  (technology-independent, generic gates)
# =====================================================================
syn_generic

report_timing                    > ../rca_4bit/reports/generic/timing_generic.rpt
report_area                      > ../rca_4bit/reports/generic/area_generic.rpt
report_power                     > ../rca_4bit/reports/generic/power_generic.rpt
report_gates                     > ../rca_4bit/reports/generic/gates_generic.rpt
report_qor                       > ../rca_4bit/reports/generic/qor_generic.rpt

write_hdl                        > ../rca_4bit/outputs/rca_4bit_generic.v
write_sdc                        > ../rca_4bit/outputs/rca_4bit_generic.sdc

# =====================================================================
# STAGE 2 : MAPPED SYNTHESIS  (technology-mapped to standard cells)
# =====================================================================
syn_map

report_timing                    > ../rca_4bit/reports/mapped/timing_mapped.rpt
report_area                      > ../rca_4bit/reports/mapped/area_mapped.rpt
report_power                     > ../rca_4bit/reports/mapped/power_mapped.rpt
report_gates                     > ../rca_4bit/reports/mapped/gates_mapped.rpt
report_qor                       > ../rca_4bit/reports/mapped/qor_mapped.rpt

write_hdl                        > ../rca_4bit/outputs/rca_4bit_mapped.v
write_sdc                        > ../rca_4bit/outputs/rca_4bit_mapped.sdc

# =====================================================================
# STAGE 3 : OPTIMIZED / INCREMENTAL SYNTHESIS  (final optimization pass)
# =====================================================================
syn_opt

report_timing                    > ../rca_4bit/reports/optimized/timing_optimized.rpt
report_area                      > ../rca_4bit/reports/optimized/area_optimized.rpt
report_power                     > ../rca_4bit/reports/optimized/power_optimized.rpt
report_gates                     > ../rca_4bit/reports/optimized/gates_optimized.rpt
report_qor                       > ../rca_4bit/reports/optimized/qor_optimized.rpt

write_hdl                        > ../rca_4bit/outputs/rca_4bit_optimized.v
write_sdc                        > ../rca_4bit/outputs/rca_4bit_optimized.sdc

# ---------------------------------------------------------------
# 4. Final netlist + design checks
# ---------------------------------------------------------------
check_design                     > ../rca_4bit/reports/optimized/check_design.rpt

puts "=============================================="
puts " RCA 4-bit synthesis COMPLETE."
puts " Reports written under rca_4bit/reports/{generic,mapped,optimized}"
puts " Netlists written under rca_4bit/outputs/"
puts "=============================================="

exit
