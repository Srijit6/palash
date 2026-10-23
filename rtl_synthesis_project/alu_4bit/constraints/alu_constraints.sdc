# =====================================================================
# SDC Constraints : 4-bit Sequential ALU (alu_4bit_seq)
# Design type     : Sequential -> real clock port "clk" exists.
# =====================================================================

# ---------------------------------------------------------------
# 1. Real clock definition on port clk (100 MHz, 10 ns period)
# ---------------------------------------------------------------
create_clock -name clk -period 10.0 [get_ports clk]

# ---------------------------------------------------------------
# 2. Input delay on all data inputs EXCEPT clk / rst_n
#    (2 ns after the clock edge)
# ---------------------------------------------------------------
set_input_delay -clock clk 2.0 [get_ports {A B opcode}]

# rst_n is typically treated as asynchronous / exceptions applied
set_false_path -from [get_ports rst_n]

# ---------------------------------------------------------------
# 3. Output delay on registered outputs
# ---------------------------------------------------------------
set_output_delay -clock clk 2.0 [get_ports {Result Cout Zero}]

# ---------------------------------------------------------------
# 4. Input transition (slew) on data inputs
# ---------------------------------------------------------------
set_input_transition 0.1 [get_ports {A B opcode}]

# ---------------------------------------------------------------
# 5. Output load on data outputs
# ---------------------------------------------------------------
set_load 0.02 [get_ports {Result Cout Zero}]

# ---------------------------------------------------------------
# 6. Clock network realism
# ---------------------------------------------------------------
set_clock_uncertainty 0.2 [get_clocks clk]
set_clock_transition   0.1 [get_clocks clk]
set_clock_latency      0.5 [get_clocks clk]

# ---------------------------------------------------------------
# 7. Design rule / environment constraints
# ---------------------------------------------------------------
set_max_transition 0.5 [current_design]
set_max_fanout      8  [current_design]
set_max_capacitance 0.1 [current_design]

# ---------------------------------------------------------------
# 8. (Optional) Reset recovery/removal - if you keep rst_n as a
#    real timed reset instead of the false_path above, comment
#    line above and uncomment this instead:
# set_input_delay -clock clk 1.0 [get_ports rst_n]
