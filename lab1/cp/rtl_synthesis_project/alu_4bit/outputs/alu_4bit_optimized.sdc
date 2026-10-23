# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Mon Sep 07 18:08:58 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design alu_4bit_seq

create_clock -name "clk" -period 10.0 -waveform {0.0 5.0} [get_ports clk]
set_clock_transition 0.1 [get_clocks clk]
set_load -pin_load 0.02 [get_ports {Result[3]}]
set_load -pin_load 0.02 [get_ports {Result[2]}]
set_load -pin_load 0.02 [get_ports {Result[1]}]
set_load -pin_load 0.02 [get_ports {Result[0]}]
set_load -pin_load 0.02 [get_ports Cout]
set_load -pin_load 0.02 [get_ports Zero]
set_false_path -from [get_ports rst_n]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {A[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {A[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {A[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {A[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {B[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {B[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {B[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {B[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {opcode[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {opcode[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {opcode[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {Result[3]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {Result[2]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {Result[1]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports {Result[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports Cout]
set_output_delay -clock [get_clocks clk] -add_delay 2.0 [get_ports Zero]
set_max_fanout 8.000 [current_design]
set_max_transition 0.5 [current_design]
set_max_capacitance 0.1 [current_design]
set_input_transition 0.1 [get_ports {A[3]}]
set_input_transition 0.1 [get_ports {A[2]}]
set_input_transition 0.1 [get_ports {A[1]}]
set_input_transition 0.1 [get_ports {A[0]}]
set_input_transition 0.1 [get_ports {B[3]}]
set_input_transition 0.1 [get_ports {B[2]}]
set_input_transition 0.1 [get_ports {B[1]}]
set_input_transition 0.1 [get_ports {B[0]}]
set_input_transition 0.1 [get_ports {opcode[2]}]
set_input_transition 0.1 [get_ports {opcode[1]}]
set_input_transition 0.1 [get_ports {opcode[0]}]
set_wire_load_mode "enclosed"
set_clock_latency  0.5 [get_clocks clk]
set_clock_uncertainty -setup 0.2 [get_clocks clk]
set_clock_uncertainty -hold 0.2 [get_clocks clk]
