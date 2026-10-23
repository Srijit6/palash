# =========================================================================
# compare_ppa.tcl
#
# FIR SYNTHESIS PPA COMPARATIVE ANALYSIS
#
# Designs:
#   1. fir
#   2. fir_piplined
#   3. fir_area_optimized
#
# Corners:
#   slow / typical / fast
#
# Nodes:
#   180nm / 90nm / 45nm
#
# Reads existing reports from:
#
#   <design>/<corner>/<node>/reports/
#
# Produces:
#
#   ppa_comparison_summary.txt
#
# IMPORTANT:
#   This script ONLY reads existing reports.
#   It does NOT re-run synthesis.
# =========================================================================


# -------------------------------------------------------------------------
# 1. PROJECT ROOT
# -------------------------------------------------------------------------

set LAB_ROOT "/home/vlsi38/24BVD1104/SUBMISSION/fir_lab"

set OUTFILE "${LAB_ROOT}/ppa_comparison_summary.txt"


# -------------------------------------------------------------------------
# 2. DESIGNS / CORNERS / TECHNOLOGY NODES
# -------------------------------------------------------------------------

set DESIGNS {
    fir
    fir_piplined
    fir_area_optimized
}

set CORNERS {
    slow
    typical
    fast
}

set NODES {
    180
    90
    45
}


# -------------------------------------------------------------------------
# 3. HELPER: READ FILE
# -------------------------------------------------------------------------

proc read_file {path} {

    if {[catch {open $path r} fh]} {
        return ""
    }

    set data [read $fh]
    close $fh

    return $data
}


# -------------------------------------------------------------------------
# 4. GENERIC NUMBER EXTRACTION
# -------------------------------------------------------------------------

proc extract_number {text pattern} {

    if {[regexp -nocase $pattern $text -> value]} {
        return $value
    }

    return "N/A"
}


# -------------------------------------------------------------------------
# 5. FIND REPORT
# -------------------------------------------------------------------------

proc find_report {dir pattern} {

    set hits [glob -nocomplain -directory $dir $pattern]

    if {[llength $hits] == 0} {
        return ""
    }

    return [lindex [lsort $hits] 0]
}


# =========================================================================
# 6. PARSE POWER
# =========================================================================

proc parse_power {path} {

    set data [read_file $path]

    if {$data eq ""} {
        return ""
    }

    set scale 1000.0

    # Detect power unit
    if {[regexp -nocase {Power Unit:\s*(\S+)} $data -> unit]} {

        switch -- [string tolower $unit] {

            w  { set scale 1000.0 }
            mw { set scale 1.0 }
            uw { set scale 0.001 }
            nw { set scale 0.000001 }
            pw { set scale 0.000000001 }

            default {
                set scale 1000.0
            }
        }
    }

    set total "N/A"
    set leakage "N/A"
    set internal "N/A"
    set switching "N/A"

    set num {[-+0-9.eE]+}

    foreach line [split $data "\n"] {

        set t [string trim $line]

        if {[regexp "^Subtotal\\s+($num)\\s+($num)\\s+($num)\\s+($num)" \
                $t -> l i s tot]} {

            set leakage   [expr {double($l) * $scale}]
            set internal  [expr {double($i) * $scale}]
            set switching [expr {double($s) * $scale}]
            set total     [expr {double($tot) * $scale}]
        }
    }

    return [dict create \
        total $total \
        leakage $leakage \
        internal $internal \
        switching $switching]
}


# =========================================================================
# 7. PARSE AREA
# =========================================================================

proc parse_area {path} {

    set data [read_file $path]

    if {$data eq ""} {
        return ""
    }

    set area "N/A"

    # Common Genus wording
    if {[regexp -nocase \
        {Total\s+(?:Cell\s+)?Area\s*[:=]?\s*([-+0-9.eE]+)} \
        $data -> value]} {

        set area $value
    }

    return [dict create total $area]
}


# =========================================================================
# 8. PARSE TIMING
# =========================================================================

proc parse_timing {path} {

    set data [read_file $path]

    if {$data eq ""} {
        return ""
    }

    set wns "N/A"
    set tns "N/A"

    # WNS
    if {[regexp -nocase \
        {Worst\s+Negative\s+Slack\s*\(?WNS\)?\s*[:=]?\s*([-+0-9.eE]+)} \
        $data -> value]} {

        set wns $value

    } elseif {[regexp -nocase \
        {WNS\s*[:=]?\s*([-+0-9.eE]+)} \
        $data -> value]} {

        set wns $value
    }


    # TNS
    if {[regexp -nocase \
        {Total\s+Negative\s+Slack\s*\(?TNS\)?\s*[:=]?\s*([-+0-9.eE]+)} \
        $data -> value]} {

        set tns $value

    } elseif {[regexp -nocase \
        {TNS\s*[:=]?\s*([-+0-9.eE]+)} \
        $data -> value]} {

        set tns $value
    }


    return [dict create \
        wns $wns \
        tns $tns]
}


# =========================================================================
# 9. COLLECT ALL DATA
# =========================================================================

set ROWS {}

set FOUND 0
set MISSING 0

set MISSING_LIST {}


foreach design $DESIGNS {

    foreach corner $CORNERS {

        foreach node $NODES {

            set report_dir \
                "${LAB_ROOT}/${design}/${corner}/${node}/reports"


            if {![file isdirectory $report_dir]} {

                incr MISSING

                lappend MISSING_LIST \
                    "$design $corner ${node}nm : reports directory missing"

                continue
            }


            # -------------------------------------------------------------
            # Locate reports
            # -------------------------------------------------------------

            set power_file \
                [find_report $report_dir "*_power.rpt"]

            set area_file \
                [find_report $report_dir "*_area.rpt"]

            set timing_file \
                [find_report $report_dir "*_timing.rpt"]


            # -------------------------------------------------------------
            # Parse
            # -------------------------------------------------------------

            set power_data ""
            set area_data ""
            set timing_data ""


            if {$power_file ne ""} {
                set power_data [parse_power $power_file]
            }

            if {$area_file ne ""} {
                set area_data [parse_area $area_file]
            }

            if {$timing_file ne ""} {
                set timing_data [parse_timing $timing_file]
            }


            # -------------------------------------------------------------
            # Store
            # -------------------------------------------------------------

            lappend ROWS [list \
                $design \
                $corner \
                $node \
                $power_data \
                $area_data \
                $timing_data]

            incr FOUND
        }
    }
}


# =========================================================================
# 10. WRITE OUTPUT
# =========================================================================

set out [open $OUTFILE w]


puts $out "================================================================================"
puts $out "             FIR SYNTHESIS - PPA COMPARATIVE ANALYSIS"
puts $out "================================================================================"
puts $out ""
puts $out "Generated : [clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}]"
puts $out "Root      : $LAB_ROOT"
puts $out ""
puts $out "Designs:"
puts $out "  fir              = Normal 4-tap FIR"
puts $out "  fir_piplined     = Pipelined 4-tap FIR"
puts $out "  fir_area_optimized = Area-Optimized 4-tap FIR"
puts $out ""
puts $out "Technology nodes:"
puts $out "  180nm / 90nm / 45nm"
puts $out ""
puts $out "Corners:"
puts $out "  slow / typical / fast"
puts $out ""
puts $out "Power units: mW"
puts $out "================================================================================"
puts $out ""


# =========================================================================
# 11. COMPLETE PPA TABLE
# =========================================================================

puts $out "PPA SUMMARY"
puts $out "--------------------------------------------------------------------------------"

puts $out [format \
    "%-20s %-8s %-6s %12s %12s %12s %12s" \
    "Design" "Corner" "Node" \
    "Area" "WNS" "TNS" "Power"]

puts $out "--------------------------------------------------------------------------------"


foreach row $ROWS {

    lassign $row design corner node power area timing

    set area_val "N/A"
    set wns_val "N/A"
    set tns_val "N/A"
    set power_val "N/A"


    if {$area ne ""} {
        set area_val [dict get $area total]
    }

    if {$timing ne ""} {
        set wns_val [dict get $timing wns]
        set tns_val [dict get $timing tns]
    }

    if {$power ne ""} {
        set power_val [dict get $power total]
    }


    puts $out [format \
        "%-20s %-8s %-6s %12s %12s %12s %12s" \
        $design \
        $corner \
        "${node}nm" \
        $area_val \
        $wns_val \
        $tns_val \
        $power_val]
}


puts $out "--------------------------------------------------------------------------------"
puts $out ""


# =========================================================================
# 12. DESIGN COMPARISON AT 90nm SLOW CORNER
# =========================================================================

puts $out "================================================================================"
puts $out "                    90nm SLOW-CORNER COMPARISON"
puts $out "================================================================================"
puts $out ""

puts $out [format \
    "%-24s %15s %15s %15s" \
    "Metric" \
    "Normal FIR" \
    "Pipelined FIR" \
    "Area Optimized"]

puts $out "--------------------------------------------------------------------------------"


foreach metric {area power wns tns} {

    set values {N/A N/A N/A}

    set index 0

    foreach design $DESIGNS {

        foreach row $ROWS {

            lassign $row d c n power area timing

            if {$d eq $design && $c eq "slow" && $n == 90} {

                if {$metric eq "area" && $area ne ""} {
                    set value [dict get $area total]
                } elseif {$metric eq "power" && $power ne ""} {
                    set value [dict get $power total]
                } elseif {$metric eq "wns" && $timing ne ""} {
                    set value [dict get $timing wns]
                } elseif {$metric eq "tns" && $timing ne ""} {
                    set value [dict get $timing tns]
                } else {
                    set value "N/A"
                }

                lset values $index $value
            }
        }

        incr index
    }


    set label $metric

    switch -- $metric {
        area  { set label "Total Area" }
        power { set label "Total Power (mW)" }
        wns   { set label "WNS" }
        tns   { set label "TNS" }
    }


    puts $out [format \
        "%-24s %15s %15s %15s" \
        $label \
        [lindex $values 0] \
        [lindex $values 1] \
        [lindex $values 2]]
}


puts $out "--------------------------------------------------------------------------------"
puts $out ""


# =========================================================================
# 13. DESIGN COMPARISON FOR EVERY NODE - SLOW CORNER
# =========================================================================

puts $out "================================================================================"
puts $out "                    DESIGN COMPARISON - SLOW CORNER"
puts $out "================================================================================"
puts $out ""

puts $out [format \
    "%-8s %-15s %-15s %-15s %-15s" \
    "Node" "Metric" "Normal" "Pipelined" "Area-Optimized"]

puts $out "--------------------------------------------------------------------------------"


foreach node $NODES {

    foreach metric {area power wns} {

        set values {N/A N/A N/A}

        set index 0

        foreach design $DESIGNS {

            foreach row $ROWS {

                lassign $row d c n power area timing

                if {$d eq $design && $c eq "slow" && $n == $node} {

                    if {$metric eq "area" && $area ne ""} {
                        set value [dict get $area total]
                    } elseif {$metric eq "power" && $power ne ""} {
                        set value [dict get $power total]
                    } elseif {$metric eq "wns" && $timing ne ""} {
                        set value [dict get $timing wns]
                    } else {
                        set value "N/A"
                    }

                    lset values $index $value
                }
            }

            incr index
        }


        puts $out [format \
            "%-8s %-15s %-15s %-15s %-15s" \
            "${node}nm" \
            $metric \
            [lindex $values 0] \
            [lindex $values 1] \
            [lindex $values 2]]
    }

    puts $out ""
}


puts $out "--------------------------------------------------------------------------------"
puts $out ""


# =========================================================================
# 14. NOTES
# =========================================================================

puts $out "================================================================================"
puts $out "NOTES"
puts $out "================================================================================"
puts $out ""

puts $out "1. Comparisons between architectures should be made at the SAME"
puts $out "   technology node and SAME process corner."

puts $out ""

puts $out "2. The 90nm slow corner is the primary comparison point for the"
puts $out "   physical-design assignment."

puts $out ""

puts $out "3. Lower Area is generally better."

puts $out ""

puts $out "4. Lower Power is generally better."

puts $out ""

puts $out "5. Higher WNS is better. WNS >= 0 indicates timing closure."

puts $out ""

puts $out "6. TNS closer to 0 is better. TNS = 0 indicates no total"
puts $out "   negative slack."

puts $out ""

puts $out "7. The pipelined architecture may trade increased area/power"
puts $out "   for improved timing."

puts $out ""

puts $out "8. The area-optimized architecture should primarily be evaluated"
puts $out "   for reduction in area while maintaining acceptable timing."

puts $out ""

puts $out "================================================================================"
puts $out "Reports discovered: $FOUND"
puts $out "Missing/unreadable configurations: $MISSING"
puts $out "================================================================================"


if {$MISSING > 0} {

    puts $out ""
    puts $out "MISSING CONFIGURATIONS"
    puts $out "--------------------------------------------------------------------------------"

    foreach item $MISSING_LIST {
        puts $out $item
    }
}


close $out


# =========================================================================
# 15. CONSOLE MESSAGE
# =========================================================================

puts ""
puts "=============================================================="
puts " FIR PPA COMPARATIVE ANALYSIS COMPLETE"
puts "=============================================================="
puts ""
puts "Configurations found : $FOUND"
puts "Missing              : $MISSING"
puts ""
puts "Output:"
puts "$OUTFILE"
puts ""
puts "=============================================================="
