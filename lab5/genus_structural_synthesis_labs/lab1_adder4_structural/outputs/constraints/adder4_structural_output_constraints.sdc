# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Fri Jul 31 12:45:37 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design adder4_structural

create_clock -name "VIRTUAL_CLK" -period 10.0 -waveform {0.0 5.0} 
set_load -pin_load 0.05 [get_ports {sum[3]}]
set_load -pin_load 0.05 [get_ports {sum[2]}]
set_load -pin_load 0.05 [get_ports {sum[1]}]
set_load -pin_load 0.05 [get_ports {sum[0]}]
set_load -pin_load 0.05 [get_ports cout]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {a[3]}]
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {a[2]}]
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {a[1]}]
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {a[0]}]
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {b[3]}]
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {b[2]}]
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {b[1]}]
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {b[0]}]
set_input_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports cin]
set_output_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {sum[3]}]
set_output_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {sum[2]}]
set_output_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {sum[1]}]
set_output_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports {sum[0]}]
set_output_delay -clock [get_clocks VIRTUAL_CLK] -add_delay 1.0 [get_ports cout]
set_max_fanout 8.000 [current_design]
set_max_transition 0.5 [current_design]
set_wire_load_mode "enclosed"
