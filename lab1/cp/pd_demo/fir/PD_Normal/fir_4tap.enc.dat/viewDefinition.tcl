if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name max_time\
   -timing\
    [list ${::IMEX::libVar}/mmmc/slow.lib]
create_library_set -name min_time\
   -timing\
    [list ${::IMEX::libVar}/mmmc/fast.lib]
create_rc_corner -name default_rc_corner\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name max_delay\
   -library_set max_time
create_delay_corner -name min_delay\
   -library_set min_time
create_constraint_mode -name fir_constraints\
   -sdc_files\
    [list /dev/null]
create_analysis_view -name setup_new -constraint_mode fir_constraints -delay_corner max_delay
create_analysis_view -name hold_view -constraint_mode fir_constraints -delay_corner min_delay
set_analysis_view -setup [list setup_new] -hold [list hold_view]
