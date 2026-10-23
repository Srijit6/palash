# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Thu Sep 10 17:43:16 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design fir_4tap_pipelined

create_clock -name "CLK" -period 10.0 -waveform {0.0 5.0} [get_ports clk]
set_clock_transition 0.1 [get_clocks CLK]
set_load -pin_load 0.05 [get_ports {yout[17]}]
set_load -pin_load 0.05 [get_ports {yout[16]}]
set_load -pin_load 0.05 [get_ports {yout[15]}]
set_load -pin_load 0.05 [get_ports {yout[14]}]
set_load -pin_load 0.05 [get_ports {yout[13]}]
set_load -pin_load 0.05 [get_ports {yout[12]}]
set_load -pin_load 0.05 [get_ports {yout[11]}]
set_load -pin_load 0.05 [get_ports {yout[10]}]
set_load -pin_load 0.05 [get_ports {yout[9]}]
set_load -pin_load 0.05 [get_ports {yout[8]}]
set_load -pin_load 0.05 [get_ports {yout[7]}]
set_load -pin_load 0.05 [get_ports {yout[6]}]
set_load -pin_load 0.05 [get_ports {yout[5]}]
set_load -pin_load 0.05 [get_ports {yout[4]}]
set_load -pin_load 0.05 [get_ports {yout[3]}]
set_load -pin_load 0.05 [get_ports {yout[2]}]
set_load -pin_load 0.05 [get_ports {yout[1]}]
set_load -pin_load 0.05 [get_ports {yout[0]}]
set_false_path -from [get_ports rst]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {xin[7]}]
set_input_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {xin[6]}]
set_input_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {xin[5]}]
set_input_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {xin[4]}]
set_input_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {xin[3]}]
set_input_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {xin[2]}]
set_input_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {xin[1]}]
set_input_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {xin[0]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[17]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[16]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[15]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[14]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[13]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[12]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[11]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[10]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[9]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[8]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[7]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[6]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[5]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[4]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[3]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[2]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[1]}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {yout[0]}]
set_max_fanout 8.000 [current_design]
set_max_transition 0.5 [current_design]
set_wire_load_mode "enclosed"
set_clock_uncertainty -setup 0.2 [get_clocks CLK]
set_clock_uncertainty -hold 0.2 [get_clocks CLK]
