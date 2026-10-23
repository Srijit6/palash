# 1. Define the 250 MHz Clock (Period = 4.0ns)
create_clock -name clk -period 4.0 [get_ports clk]

# 2. Add Clock Uncertainty (Simulates real-world jitter for setup/hold analysis)
set_clock_uncertainty -setup 0.200 [get_clocks clk]
set_clock_uncertainty -hold  0.050 [get_clocks clk]

# 3. I/O Delays (Accounts for logic outside this MAC unit)
set_input_delay  -clock clk 1.0 [all_inputs -no_clocks]
set_output_delay -clock clk 1.0 [all_outputs]

# 4. Environment: Driving Cells and Loads (For .lib delay calculations)
set_driving_cell -lib_cell INV_X1 [all_inputs -no_clocks]
set_load 0.05 [all_outputs]

# 5. Design Rule Constraints (DRC)
set_max_transition 0.5 [current_design]
