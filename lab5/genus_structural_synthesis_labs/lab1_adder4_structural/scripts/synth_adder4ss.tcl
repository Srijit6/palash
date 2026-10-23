###########################################################################
#               UNIVERSAL CADENCE GENUS SYNTHESIS SCRIPT
#
# Edit ONLY the variables in the PROJECT CONFIGURATION section.
# Everything else automatically uses those paths.
###########################################################################

###############################
# PROJECT CONFIGURATION
###############################

# Root directory of the project
set PROJECT_DIR "/home/vlsi16/24bvd1023/lab5/genus_structural_synthesis_labs/lab1_adder4_structural"

# Design name (Top Module)
set TOP_MODULE "adder4_structural"

# Library location
set LIB_DIR "/home/install/FOUNDRY/digital/90nm/dig/lib"

# Library file
set LIB_FILE "slow.lib"

# RTL directory
set RTL_DIR "$PROJECT_DIR/rtl"

# Constraint directory
set CONSTRAINT_DIR "$PROJECT_DIR/constraints"

# Output directory
set OUTPUT_DIR "$PROJECT_DIR/outputs"

# Report directory
set REPORT_DIR "$OUTPUT_DIR/reports"

# Netlist directory
set NETLIST_DIR "$OUTPUT_DIR/netlist"

# Output SDC directory
set OUTPUT_SDC_DIR "$OUTPUT_DIR/constraints"

# Constraint file
set SDC_FILE "$CONSTRAINT_DIR/adder4_constraints.sdc"

# RTL files
set RTL_FILES {
    full_adder.v
    adder4_structural.v
}

###############################
# CREATE OUTPUT DIRECTORIES
###############################

file mkdir $OUTPUT_DIR
file mkdir $REPORT_DIR
file mkdir $NETLIST_DIR
file mkdir $OUTPUT_SDC_DIR

###############################
# SEARCH PATHS
###############################

set_db init_lib_search_path $LIB_DIR
set_db init_hdl_search_path $RTL_DIR

###############################
# READ LIBRARY
###############################

read_libs $LIB_FILE

###############################
# READ RTL
###############################

read_hdl $RTL_FILES

###############################
# ELABORATE
###############################

elaborate $TOP_MODULE

###############################
# CLOCK
###############################

# Virtual clock (for combinational designs)

create_clock -name VIRTUAL_CLK -period 10.0

###############################
# READ CONSTRAINTS
###############################

read_sdc $SDC_FILE

###############################
# SYNTHESIS SETTINGS
###############################

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

###############################
# DESIGN CHECKS
###############################

check_design -unresolved > "$REPORT_DIR/${TOP_MODULE}_check_design.rpt"


###############################
# GENERIC SYNTHESIS
###############################

syn_generic

write_hdl > "$NETLIST_DIR/${TOP_MODULE}_generic.v"

###############################
# TECHNOLOGY MAPPING
###############################

syn_map

write_hdl > "$NETLIST_DIR/${TOP_MODULE}_mapped.v"

###############################
# OPTIMIZATION
###############################

syn_opt

###############################
# SAVE RESULTS
###############################

write_hdl > "$NETLIST_DIR/${TOP_MODULE}_netlist.v"

write_sdc > "$OUTPUT_SDC_DIR/${TOP_MODULE}_output_constraints.sdc"

###############################
# REPORTS
###############################

report_timing > "$REPORT_DIR/${TOP_MODULE}_timing.rpt"

report_area > "$REPORT_DIR/${TOP_MODULE}_area.rpt"

report_gates > "$REPORT_DIR/${TOP_MODULE}_gates.rpt"

report_power > "$REPORT_DIR/${TOP_MODULE}_power_vectorless.rpt"

report_qor > "$REPORT_DIR/${TOP_MODULE}_qor.rpt"

###############################
# COMPLETION MESSAGE
###############################

puts ""
puts "======================================================="
puts "         SYNTHESIS COMPLETED SUCCESSFULLY"
puts "======================================================="
puts " Top Module : $TOP_MODULE"
puts " Project    : $PROJECT_DIR"
puts " Reports    : $REPORT_DIR"
puts " Netlists   : $NETLIST_DIR"
puts "======================================================="

# Uncomment to open GUI
gui_show

#exit
