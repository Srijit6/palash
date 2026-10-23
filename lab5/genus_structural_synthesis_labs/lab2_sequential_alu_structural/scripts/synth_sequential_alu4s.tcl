###########################################################################
#                 UNIVERSAL CADENCE GENUS SYNTHESIS SCRIPT
#          Sequential Design (Combinational ALU + Registered Output)
#
# Edit ONLY the PROJECT CONFIGURATION section below.
###########################################################################

###############################
# PROJECT CONFIGURATION
###############################

# Project Root Directory
set PROJECT_DIR "/home/vlsi/Desktop/test_sms/genus_structural_synthesis_labs/lab2_sequential_alu_structural"

# Top Module Name
set TOP_MODULE "sequential_alu4_structural"

# Library Directory
set LIB_DIR "/home/install/FOUNDRY/digital/90nm/dig/lib"

# Technology Library
set LIB_FILE "slow.lib"

# RTL Directory
set RTL_DIR "$PROJECT_DIR/rtl"

# Constraints Directory
set CONSTRAINT_DIR "$PROJECT_DIR/constraints"

# Output Directory
set OUTPUT_DIR "$PROJECT_DIR/outputs"

# Report Directory
set REPORT_DIR "$OUTPUT_DIR/reports"

# Netlist Directory
set NETLIST_DIR "$OUTPUT_DIR/netlist"

# Output Constraint Directory
set OUTPUT_SDC_DIR "$OUTPUT_DIR/constraints"

# Log Directory
set LOG_DIR "$OUTPUT_DIR/logs"

# VCD File (Optional)
set VCD_FILE "$OUTPUT_DIR/sequential_alu4.vcd"

# Constraint File
set SDC_FILE "$CONSTRAINT_DIR/sequential_alu4_constraints.sdc"

# RTL Files (Edit as required)
set RTL_FILES {
    full_adder.v
    ripple_adder4.v
    mux2_1.v
    mux4_1.v
    dff_async_reset.v
    alu4_comb_structural.v
    sequential_alu4_structural.v
}

###############################
# CREATE OUTPUT DIRECTORIES
###############################

file mkdir $OUTPUT_DIR
file mkdir $REPORT_DIR
file mkdir $NETLIST_DIR
file mkdir $OUTPUT_SDC_DIR
file mkdir $LOG_DIR

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
# ELABORATE DESIGN
###############################

elaborate $TOP_MODULE

###############################
# READ CONSTRAINTS
###############################

read_sdc $SDC_FILE

###############################
# OPTIONAL VCD ACTIVITY
###############################

if {[file exists $VCD_FILE]} {

    puts ""
    puts "------------------------------------------"
    puts "Reading Switching Activity"
    puts "$VCD_FILE"
    puts "------------------------------------------"

    read_vcd $VCD_FILE

} else {

    puts ""
    puts "------------------------------------------"
    puts "WARNING : VCD File Not Found"
    puts "Using Vectorless Power Estimation"
    puts "------------------------------------------"

}

###############################
# SYNTHESIS SETTINGS
###############################

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

###############################
# DESIGN CHECKS
###############################

check_design -unresolved \
> "$REPORT_DIR/${TOP_MODULE}_check_design.rpt"

###############################
# GENERIC SYNTHESIS
###############################

syn_generic

write_hdl \
> "$NETLIST_DIR/${TOP_MODULE}_generic.v"

###############################
# TECHNOLOGY MAPPING
###############################

syn_map

write_hdl \
> "$NETLIST_DIR/${TOP_MODULE}_mapped.v"

###############################
# OPTIMIZATION
###############################

syn_opt

###############################
# SAVE NETLIST
###############################

write_hdl \
> "$NETLIST_DIR/${TOP_MODULE}_netlist.v"

###############################
# SAVE OUTPUT SDC
###############################

write_sdc \
> "$OUTPUT_SDC_DIR/${TOP_MODULE}_output_constraints.sdc"

###############################
# REPORTS
###############################

report_timing \
> "$REPORT_DIR/${TOP_MODULE}_timing.rpt"

report_area \
> "$REPORT_DIR/${TOP_MODULE}_area.rpt"

report_gates \
> "$REPORT_DIR/${TOP_MODULE}_gates.rpt"

report_power \
> "$REPORT_DIR/${TOP_MODULE}_power.rpt"

report_qor \
> "$REPORT_DIR/${TOP_MODULE}_qor.rpt"

###############################
# SUMMARY
###############################

puts ""
puts "==========================================================="
puts "        CADENCE GENUS SYNTHESIS COMPLETED"
puts "==========================================================="
puts " Top Module   : $TOP_MODULE"
puts " Project      : $PROJECT_DIR"
puts " RTL Folder   : $RTL_DIR"
puts " Constraints  : $CONSTRAINT_DIR"
puts " Reports      : $REPORT_DIR"
puts " Netlists     : $NETLIST_DIR"
puts " Library      : $LIB_FILE"
puts "==========================================================="

# Uncomment for GUI
 gui_show

#exit
