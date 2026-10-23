#============================================================
# CADENCE GENUS - SIMPLE SYNTHESIS SCRIPT
# Run from the scripts folder:
#   cd scripts
#   genus -f synthesis_only.tcl
#============================================================

# 1. Search paths
set_db init_lib_search_path ../LIB/
set_db init_hdl_search_path ../RTL/

# 2. Read library
read_libs teaching_base.lib

# 3. Read RTL and elaborate top module
read_hdl activity_power_top.v
elaborate activity_power_top

# 4. Read timing constraints
read_sdc ../constraints/constraints_top.sdc

# 5. Synthesis effort
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

# 6. Run synthesis
syn_generic
syn_map
syn_opt

# 7. Reports
report_timing > ../reports/synthesis/report_timing.rpt
report_power  > ../reports/synthesis/report_power.rpt
report_area   > ../reports/synthesis/report_area.rpt
report_qor    > ../reports/synthesis/report_qor.rpt

# 8. Outputs
write_hdl > ../outputs/activity_power_top_netlist.v
write_sdc > ../outputs/activity_power_top_sdc.sdc

puts "SYNTHESIS COMPLETED"
