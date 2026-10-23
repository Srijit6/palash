# =====================================================================
# SDC Constraints : 4-bit Ripple Carry Adder (rca_4bit)
# Design type     : Purely combinational -> NO physical clock port.
# Strategy        : Create a VIRTUAL clock so Genus has a timing
#                    reference against which input/output delays,
#                    transitions and loads can be measured.
# =====================================================================

# ---------------------------------------------------------------
# 1. Virtual clock (not attached to any port, name only)
# ---------------------------------------------------------------
create_clock -name virtual_clk -period 10.0

# ---------------------------------------------------------------
# 2. Input delay - assume inputs arrive 2 ns after virtual_clk edge
# ---------------------------------------------------------------
set_input_delay -clock virtual_clk 2.0 [get_ports {A B Cin}]

# ---------------------------------------------------------------
# 3. Output delay - outputs must be valid 2 ns before next edge
# ---------------------------------------------------------------
set_output_delay -clock virtual_clk 2.0 [get_ports {Sum Cout}]

# ---------------------------------------------------------------
# 4. Input transition (slew) - models driving-cell output slew
# ---------------------------------------------------------------
set_input_transition 0.1 [get_ports {A B Cin}]

# ---------------------------------------------------------------
# 5. Output load - models fan-out capacitance seen at outputs
#    (value in the load unit of your technology library, e.g. pF)
# ---------------------------------------------------------------
set_load 0.02 [get_ports {Sum Cout}]

# ---------------------------------------------------------------
# 6. (Optional) Design rule / environment constraints
# ---------------------------------------------------------------
set_max_transition 0.5 [current_design]
set_max_fanout      8  [current_design]
set_max_capacitance 0.1 [current_design]

# ---------------------------------------------------------------
# 7. (Optional) Clock uncertainty on the virtual clock, useful
#    if you want a small pessimism margin
# ---------------------------------------------------------------
set_clock_uncertainty 0.1 [get_clocks virtual_clk]
