#=========================================================================
# Genus synthesis sweep : all 4-tap FIR variants
#
#   Designs : fir, fir_piplined, fir_area_optimized
#   Nodes   : 180nm, 90nm, 45nm
#   Corners : slow, typical, fast
#   Total   : 27 synthesis runs
#
# WHY THIS SCRIPT LAUNCHES ITSELF
# -------------------------------
# A Genus session can load only ONE library set. After the first
# read_libs, the library is locked for the life of the process:
#     "Cannot modify library search path after reading library(s) [TUI-83]"
#     "Cannot use read_libs after read_mmmc"
# So a multi-PVT sweep cannot run inside one genus invocation.
#
# This file therefore runs in two modes:
#   PARENT mode - loads no libraries; just loops over the 18 configs and
#                 launches a fresh child genus process for each one.
#   CHILD  mode - triggered by the FIR_SWEEP_CFG environment variable;
#                 performs exactly one synthesis run, then exits.
# You only ever invoke it the normal way; the child mode is automatic.
#
# USAGE
#     cd /home/vlsi38/24BVD1104/SUBMISSION/fir_lab
#     genus -f syn_all.tcl
#
# OUTPUTS (created automatically)
#     <design>/<corner>/<node>/netlist/
#     <design>/<corner>/<node>/constraints/
#     <design>/<corner>/<node>/reports/
#     <design>/<corner>/<node>/genus_run.log     <- per-run tool log
#=========================================================================

set LAB_ROOT  "/home/vlsi16/24bvd1023/fir_lab"
set GENUS_BIN "genus"

# ---- Design table ------------------------------------------------------
#   { <folder>  <top module>  <rtl file>  <sdc file> }
set DESIGNS {
    {fir                 fir_4tap              fir_4tap.v              fir_4tap.sdc}
    {fir_piplined        fir_4tap_pipelined    fir_4tap_pipelined.v    fir_4tap_pipelined.sdc}
    {fir_area_optimized  fir_4tap_shared_mult  fir_4tap_shared_mult.v  fir_4tap_shared_mult.sdc}
}

# ---- Library table -----------------------------------------------------
# The 90nm and 180nm entries are confirmed working.
# Corner naming varies by kit; find_lib below handles typ/nominal variants.
set LIB_DIR(180) "/home/install/FOUNDRY/digital/180nm/dig/lib"
set LIB_DIR(90)  "/home/install/FOUNDRY/digital/90nm/dig/lib"
set LIB_DIR(45)  "/home/install/FOUNDRY/digital/45nm/dig/lib"

set NODES   {180 90 45}
set CORNERS {slow typical fast}


#=========================================================================
# CHILD MODE - one synthesis run, then exit
#=========================================================================
if {[info exists ::env(FIR_SWEEP_CFG)]} {

    lassign [split $::env(FIR_SWEEP_CFG) "|"] \
            TOP_MODULE RTL_PATH SDC_PATH LIB_FILE LIB_PATH RUNDIR

    set_db syn_generic_effort medium
    set_db syn_map_effort     medium
    set_db syn_opt_effort     medium

    set_db init_hdl_search_path [file dirname $RTL_PATH]
    set_db init_lib_search_path $LIB_PATH

    read_libs $LIB_FILE

    read_hdl   $RTL_PATH
    elaborate  $TOP_MODULE
    read_sdc   $SDC_PATH

    syn_generic
    write_hdl > ${RUNDIR}/netlist/${TOP_MODULE}_generic.v
    syn_map
    write_hdl > ${RUNDIR}/netlist/${TOP_MODULE}_mapped.v
    syn_opt
    write_hdl > ${RUNDIR}/netlist/${TOP_MODULE}_opt.v

    write_sdc > ${RUNDIR}/constraints/${TOP_MODULE}_synth.sdc

    report_timing > ${RUNDIR}/reports/${TOP_MODULE}_timing.rpt
    report_power  > ${RUNDIR}/reports/${TOP_MODULE}_power.rpt
    report_area   > ${RUNDIR}/reports/${TOP_MODULE}_area.rpt
    report_gates  > ${RUNDIR}/reports/${TOP_MODULE}_gates.rpt
    report_qor    > ${RUNDIR}/reports/${TOP_MODULE}_qor.rpt

    exit 0
}


#=========================================================================
# PARENT MODE - dispatch one child genus run per configuration
#=========================================================================

# Locate this script so the children can be pointed at it
set SCRIPT_PATH [file normalize [info script]]
if {$SCRIPT_PATH eq "" || ![file exists $SCRIPT_PATH]} {
    set SCRIPT_PATH [file join $LAB_ROOT "syn_all.tcl"]
}
if {![file exists $SCRIPT_PATH]} {
    puts "ERROR: cannot locate this script to re-launch. Expected: $SCRIPT_PATH"
    exit 1
}

if {[auto_execok $GENUS_BIN] eq ""} {
    puts "ERROR: '$GENUS_BIN' not found in PATH."
    exit 1
}

# Locate the .lib for a corner.
# Corners are named inconsistently across foundry kits, so each corner has
# a list of aliases. For every alias we try <alias>.lib first, then any
# *<alias>*.lib in the directory (catches slow_vdd1v8_basicCells.lib etc).
proc find_lib {dir corner} {

    switch -- $corner {
        slow    { set aliases {slow} }
        fast    { set aliases {fast} }
        typical { set aliases {typical typ nominal nom} }
        default { set aliases [list $corner] }
    }

    # Exact filename match wins for any alias
    foreach a $aliases {
        set exact [file join $dir "${a}.lib"]
        if {[file exists $exact]} { return $exact }
    }

    # Fall back to a substring match, alias order preserved
    foreach a $aliases {
        set hits [glob -nocomplain -directory $dir "*${a}*.lib"]
        if {[llength $hits] > 0} { return [lindex [lsort $hits] 0] }
    }

    return ""
}

set SUMMARY {}
set NRUN 0
set NOK  0

puts "\n#########################################################"
puts "# FIR synthesis sweep"
puts "# Script : $SCRIPT_PATH"
puts "# Root   : $LAB_ROOT"
puts "#########################################################"

foreach entry $DESIGNS {

    lassign $entry FOLDER TOP_MODULE RTL_FILE SDC_FILE

    set SRC_DIR  "${LAB_ROOT}/${FOLDER}"
    set RTL_PATH "${SRC_DIR}/${RTL_FILE}"
    set SDC_PATH "${SRC_DIR}/${SDC_FILE}"

    if {![file isdirectory $SRC_DIR]} {
        puts "WARNING: design folder not found, skipping : $SRC_DIR"
        lappend SUMMARY [format "%-20s %-8s %-5s  SKIPPED (no folder)" $FOLDER - -]
        continue
    }
    if {![file exists $RTL_PATH]} {
        puts "WARNING: RTL not found, skipping : $RTL_PATH"
        lappend SUMMARY [format "%-20s %-8s %-5s  SKIPPED (no RTL)" $FOLDER - -]
        continue
    }
    if {![file exists $SDC_PATH]} {
        puts "WARNING: SDC not found, skipping : $SDC_PATH"
        lappend SUMMARY [format "%-20s %-8s %-5s  SKIPPED (no SDC)" $FOLDER - -]
        continue
    }

    foreach corner $CORNERS {
        foreach node $NODES {

            set dir $LIB_DIR($node)

            if {![file isdirectory $dir]} {
                puts "WARNING: library dir missing, skipping ${FOLDER} ${corner}/${node} : $dir"
                lappend SUMMARY [format "%-20s %-8s %-5s  SKIPPED (no lib dir)" $FOLDER $corner $node]
                continue
            }

            set libfile [find_lib $dir $corner]
            if {$libfile eq ""} {
                puts "WARNING: no '$corner' .lib in $dir, skipping ${FOLDER} ${corner}/${node}"
                lappend SUMMARY [format "%-20s %-8s %-5s  SKIPPED (no lib file)" $FOLDER $corner $node]
                continue
            }

            set RUNDIR "${SRC_DIR}/${corner}/${node}"
            file mkdir ${RUNDIR}/netlist
            file mkdir ${RUNDIR}/constraints
            file mkdir ${RUNDIR}/reports

            set LOGFILE "${RUNDIR}/genus_run.log"

            incr NRUN
            puts "\n========================================================="
            puts " \[$NRUN\] $TOP_MODULE   ($FOLDER)"
            puts "     Node    : ${node}nm     Corner : $corner"
            puts "     Library : $libfile"
            puts "     Output  : $RUNDIR"
            puts "     Log     : $LOGFILE"
            puts "========================================================="
            flush stdout

            # Hand the config to the child through the environment
            set ::env(FIR_SWEEP_CFG) \
                [join [list $TOP_MODULE $RTL_PATH $SDC_PATH \
                            $libfile $dir $RUNDIR] "|"]

            set rc [catch {
                exec $GENUS_BIN -overwrite \
                                -log_file $LOGFILE \
                                -files $SCRIPT_PATH \
                                >@ stdout 2>@ stderr
            } errmsg]

            unset ::env(FIR_SWEEP_CFG)

            # Confirm the run actually produced its netlist
            set produced [file exists ${RUNDIR}/netlist/${TOP_MODULE}_opt.v]

            if {$rc == 0 && $produced} {
                incr NOK
                lappend SUMMARY [format "%-20s %-8s %-5s  DONE" $FOLDER $corner $node]
            } else {
                puts "ERROR: run failed for ${FOLDER} ${corner}/${node}"
                if {$errmsg ne ""} { puts "       $errmsg" }
                puts "       See $LOGFILE"
                lappend SUMMARY [format "%-20s %-8s %-5s  FAILED (see log)" $FOLDER $corner $node]
            }
            flush stdout
        }
    }
}

# ---- Summary -----------------------------------------------------------
puts "\n===================== SWEEP SUMMARY ====================="
foreach line $SUMMARY { puts "  $line" }
puts "---------------------------------------------------------"
puts "  Completed $NOK of $NRUN attempted runs"
puts "  Reports  : <design>/<corner>/<node>/reports/"
puts "  Netlists : <design>/<corner>/<node>/netlist/"
puts "========================================================="

exit 0
