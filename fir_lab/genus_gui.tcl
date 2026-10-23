#=========================================================================
# Open a synthesised netlist in the Genus GUI
#
# Derives the technology node AND the PVT corner from the directory path,
# so the netlist is always viewed against the library it was built with.
#
# Expects the sweep layout:
#     <design>/<corner>/<node>/netlist/<top>_opt.v
#
# USAGE
#     cd <design>/<corner>/<node>/netlist
#     genus -f /home/vlsi38/24BVD1104/SUBMISSION/fir_lab/genus_gui.tcl
#
#   Optionally pick a different stage:
#     setenv NETLIST_STAGE mapped     (csh/tcsh)
#     export NETLIST_STAGE=mapped     (bash)
#   Valid stages: generic, mapped, opt (default).
#
# NOTE: needs an X display. Connect with  ssh -X  or  ssh -Y.
#=========================================================================

set LIB_ROOT "/home/install/FOUNDRY/digital"

# ---- Which stage to open ----------------------------------------------
set stage "opt"
if {[info exists ::env(NETLIST_STAGE)]} {
    set stage $::env(NETLIST_STAGE)
}
if {[lsearch -exact {generic mapped opt} $stage] < 0} {
    puts "ERROR: NETLIST_STAGE must be generic, mapped or opt (got '$stage')."
    exit 1
}

# ---- Find the netlist --------------------------------------------------
set netlist_files [lsort [glob -nocomplain "*_${stage}.v"]]
if {[llength $netlist_files] == 0} {
    puts "ERROR: no *_${stage}.v in [pwd]"
    puts "       cd into a <design>/<corner>/<node>/netlist directory first."
    exit 1
}
if {[llength $netlist_files] > 1} {
    puts "NOTE: several netlists here; using [lindex $netlist_files 0]"
}
set netlist_file [lindex $netlist_files 0]

# Top module is the filename minus the stage suffix
set top_module [regsub "_${stage}\$" [file rootname $netlist_file] ""]

# ---- Work out corner and node from the path ---------------------------
# .../<design>/<corner>/<node>/netlist  ->  node = -2, corner = -3
set parts [file split [file normalize [pwd]]]
set node   ""
set corner ""
if {[llength $parts] >= 4 && [lindex $parts end] eq "netlist"} {
    set node   [lindex $parts end-1]
    set corner [lindex $parts end-2]
}

if {![regexp {^(180|90|45)$} $node] ||
    [lsearch -exact {slow typical fast} $corner] < 0} {
    puts "ERROR: cannot determine node/corner from this path:"
    puts "       [pwd]"
    puts "       Expected .../<design>/<corner>/<node>/netlist"
    puts "       corner in {slow typical fast}, node in {180 90 45}"
    exit 1
}

# ---- Locate the matching library --------------------------------------
# Exact <corner>.lib first, so macro libs like ram_*_typical_syn.lib and
# variants like typical.ecsm.lib can never be picked up by mistake.
set lib_dir "${LIB_ROOT}/${node}nm/dig/lib"

if {![file isdirectory $lib_dir]} {
    puts "ERROR: library directory not found: $lib_dir"
    exit 1
}

set lib_file ""
foreach alias [list $corner] {
    set exact [file join $lib_dir "${alias}.lib"]
    if {[file exists $exact]} { set lib_file $exact; break }
}
if {$lib_file eq ""} {
    foreach alias [list $corner] {
        set hits [lsort [glob -nocomplain -directory $lib_dir "${alias}*.lib"]]
        if {[llength $hits] > 0} { set lib_file [lindex $hits 0]; break }
    }
}
if {$lib_file eq ""} {
    puts "ERROR: no '$corner' library in $lib_dir"
    exit 1
}

# ---- Load and display --------------------------------------------------
puts "-------------------------------------------------------------"
puts " Netlist : $netlist_file"
puts " Top     : $top_module"
puts " Node    : ${node}nm      Corner : $corner"
puts " Library : $lib_file"
puts "-------------------------------------------------------------"

read_libs $lib_file
read_hdl -netlist $netlist_file
elaborate $top_module

gui_show
