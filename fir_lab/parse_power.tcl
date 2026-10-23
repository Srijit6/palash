#=========================================================================
# Power report parser for the FIR synthesis sweep
#
# Walks   <design>/<corner>/<node>/reports/*_power.rpt
# Writes  power_summary.txt   in the lab root
#
# USAGE (either works)
#     cd /home/vlsi38/24BVD1104/SUBMISSION/fir_lab
#     tclsh parse_power.tcl
#   or
#     genus -f parse_power.tcl
#
# Reads the "Subtotal" line of each report for leakage / internal /
# switching / total power, plus the register, logic and clock category
# rows. All values are normalised to milliwatts.
#=========================================================================

set LAB_ROOT "/home/vlsi38/24BVD1104/SUBMISSION/fir_lab"
set OUTFILE  "${LAB_ROOT}/power_summary.txt"

set DESIGNS {fir fir_piplined fir_area_optimized}
set CORNERS {slow typical fast}
set NODES   {180 90 45}

# ---- Unit handling -----------------------------------------------------
# Reports state their unit ("Power Unit: W"). Normalise everything to mW.
proc unit_scale {unit} {
    switch -- [string tolower $unit] {
        w   { return 1e3 }
        mw  { return 1.0 }
        uw  { return 1e-3 }
        nw  { return 1e-6 }
        pw  { return 1e-9 }
        default { return 1e3 }
    }
}

# ---- Parse one power report -------------------------------------------
# Returns a dict, or an empty string if the file could not be parsed.
proc parse_power {path} {

    if {[catch {open $path r} fh]} { return "" }
    set data [read $fh]
    close $fh

    set scale 1e3
    set res [dict create leakage 0.0 internal 0.0 switching 0.0 total 0.0 \
                         register 0.0 logic 0.0 clock 0.0 found 0]

    foreach line [split $data "\n"] {

        # "Power Unit: W"
        if {[regexp {Power Unit:\s*(\S+)} $line -> u]} {
            set scale [unit_scale $u]
            continue
        }

        set t [string trim $line]

        # Category rows: <name> <leak> <int> <sw> <total> <pct>
        # Numbers are in scientific notation, e.g. 7.99451e-08
        set num {[-+0-9.eE]+}
        if {[regexp "^(register|logic|clock)\\s+($num)\\s+($num)\\s+($num)\\s+($num)\\s" \
                    $t -> cat l i s tot]} {
            dict set res $cat [expr {double($tot) * $scale}]
            continue
        }

        # "Subtotal  <leak> <int> <sw> <total> 100.00%"
        if {[regexp "^Subtotal\\s+($num)\\s+($num)\\s+($num)\\s+($num)\\s" \
                    $t -> l i s tot]} {
            dict set res leakage   [expr {double($l)   * $scale}]
            dict set res internal  [expr {double($i)   * $scale}]
            dict set res switching [expr {double($s)   * $scale}]
            dict set res total     [expr {double($tot) * $scale}]
            dict set res found 1
        }
    }

    if {![dict get $res found]} { return "" }
    return $res
}

# ---- Collect -----------------------------------------------------------
set ROWS {}
set NFOUND 0
set NMISS  0
set MISSING {}

foreach design $DESIGNS {
    foreach corner $CORNERS {
        foreach node $NODES {

            set rptdir "${LAB_ROOT}/${design}/${corner}/${node}/reports"
            set hits [glob -nocomplain -directory $rptdir "*_power.rpt"]

            if {[llength $hits] == 0} {
                incr NMISS
                lappend MISSING [format "%-20s %-8s %-5s  no report" $design $corner $node]
                continue
            }

            set path [lindex [lsort $hits] 0]
            set top  [file rootname [file tail $path]]
            set top  [regsub {_power$} $top ""]

            set d [parse_power $path]
            if {$d eq ""} {
                incr NMISS
                lappend MISSING [format "%-20s %-8s %-5s  unreadable: %s" \
                                        $design $corner $node [file tail $path]]
                continue
            }

            incr NFOUND
            lappend ROWS [list $design $corner $node $top $d]
        }
    }
}

# ---- Write the summary -------------------------------------------------
set out [open $OUTFILE w]

puts $out "========================================================================================="
puts $out " FIR SYNTHESIS - POWER SUMMARY"
puts $out " Generated : [clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}]"
puts $out " Root      : $LAB_ROOT"
puts $out " All values in milliwatts (mW)"
puts $out "========================================================================================="
puts $out ""

# --- Main table
puts $out "TOTAL POWER BREAKDOWN"
puts $out "-----------------------------------------------------------------------------------------"
puts $out [format "%-20s %-8s %-5s %12s %12s %12s %12s" \
                  "Design" "Corner" "Node" "Leakage" "Internal" "Switching" "TOTAL"]
puts $out "-----------------------------------------------------------------------------------------"

set last ""
foreach row $ROWS {
    lassign $row design corner node top d
    if {$last ne "" && $last ne $design} { puts $out "" }
    set last $design
    puts $out [format "%-20s %-8s %-5s %12.6f %12.6f %12.6f %12.6f" \
                      $design $corner "${node}nm" \
                      [dict get $d leakage]   [dict get $d internal] \
                      [dict get $d switching] [dict get $d total]]
}
puts $out "-----------------------------------------------------------------------------------------"
puts $out ""
puts $out ""

# --- Category table
puts $out "POWER BY CATEGORY"
puts $out "-----------------------------------------------------------------------------------------"
puts $out [format "%-20s %-8s %-5s %12s %12s %12s %12s" \
                  "Design" "Corner" "Node" "Register" "Logic" "Clock" "TOTAL"]
puts $out "-----------------------------------------------------------------------------------------"

set last ""
foreach row $ROWS {
    lassign $row design corner node top d
    if {$last ne "" && $last ne $design} { puts $out "" }
    set last $design
    puts $out [format "%-20s %-8s %-5s %12.6f %12.6f %12.6f %12.6f" \
                      $design $corner "${node}nm" \
                      [dict get $d register] [dict get $d logic] \
                      [dict get $d clock]    [dict get $d total]]
}
puts $out "-----------------------------------------------------------------------------------------"
puts $out ""
puts $out ""

# --- Design comparison at each node/corner
puts $out "DESIGN COMPARISON (total power, mW)"
puts $out "-----------------------------------------------------------------------------------------"
puts $out [format "%-8s %-5s %18s %18s %18s" \
                  "Corner" "Node" "fir" "fir_piplined" "fir_area_optim"]
puts $out "-----------------------------------------------------------------------------------------"

foreach corner $CORNERS {
    foreach node $NODES {
        set cells {}
        foreach design $DESIGNS {
            set val "-"
            foreach row $ROWS {
                lassign $row d2 c2 n2 t2 dd
                if {$d2 eq $design && $c2 eq $corner && $n2 eq $node} {
                    set val [format "%.6f" [dict get $dd total]]
                    break
                }
            }
            lappend cells $val
        }
        puts $out [format "%-8s %-5s %18s %18s %18s" \
                          $corner "${node}nm" \
                          [lindex $cells 0] [lindex $cells 1] [lindex $cells 2]]
    }
}
puts $out "-----------------------------------------------------------------------------------------"
puts $out ""

# --- Lowest / highest
if {$NFOUND > 0} {
    set best   [lindex $ROWS 0]
    set worst  [lindex $ROWS 0]
    foreach row $ROWS {
        if {[dict get [lindex $row 4] total] < [dict get [lindex $best 4] total]}  { set best  $row }
        if {[dict get [lindex $row 4] total] > [dict get [lindex $worst 4] total]} { set worst $row }
    }
    puts $out "NOTES"
    puts $out "-----------------------------------------------------------------------------------------"
    puts $out [format "  Lowest total power  : %s %s %snm  (%.6f mW)" \
                      [lindex $best 0] [lindex $best 1] [lindex $best 2] \
                      [dict get [lindex $best 4] total]]
    puts $out [format "  Highest total power : %s %s %snm  (%.6f mW)" \
                      [lindex $worst 0] [lindex $worst 1] [lindex $worst 2] \
                      [dict get [lindex $worst 4] total]]
    puts $out ""
    puts $out "  Power is reported at each library's own nominal voltage and temperature,"
    puts $out "  so figures across different nodes are not a like-for-like comparison."
    puts $out "  Comparisons between the three designs at the SAME node and corner are valid."
    puts $out "-----------------------------------------------------------------------------------------"
    puts $out ""
}

# --- Anything missing
if {$NMISS > 0} {
    puts $out "MISSING OR UNREADABLE"
    puts $out "-----------------------------------------------------------------------------------------"
    foreach m $MISSING { puts $out "  $m" }
    puts $out "-----------------------------------------------------------------------------------------"
    puts $out ""
}

puts $out "Parsed $NFOUND report(s); $NMISS missing or unreadable."
close $out

# ---- Console echo ------------------------------------------------------
puts "Parsed $NFOUND power report(s); $NMISS missing or unreadable."
puts "Summary written to: $OUTFILE"
