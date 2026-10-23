if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name Min_timing\
   -timing\
    [list ${::IMEX::libVar}/mmmc/fast.lib]
create_library_set -name Max_timing\
   -timing\
    [list ${::IMEX::libVar}/mmmc/slow.lib]
create_rc_corner -name default_rc_corner\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name Max_delay\
   -library_set Max_timing
create_delay_corner -name Min_delay\
   -library_set Min_timing
create_constraint_mode -name constraints\
   -sdc_files\
    [list /dev/null]
create_analysis_view -name Best_case -constraint_mode constraints -delay_corner Min_delay
create_analysis_view -name worst_case -constraint_mode constraints -delay_corner Max_delay
set_analysis_view -setup [list worst_case] -hold [list Best_case]
