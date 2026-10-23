################################################################################
# SDC Constraints for fir_4tap
# Target Frequency Example: 100 MHz (Period: 10.0 ns)
################################################################################

# ------------------------------------------------------------------------------
# 1. Clock Definition
# ------------------------------------------------------------------------------
create_clock -name Clk -period 10.0 [get_ports Clk]

# Set clock network uncertainties (jitter, skew margins)
set_clock_uncertainty 0.2 [get_clocks Clk]

# Set clock transition (slew rate)
set_clock_transition 0.1 [get_clocks Clk]

# ------------------------------------------------------------------------------
# 2. Input Delays
# ------------------------------------------------------------------------------
# Assuming external launcher register clock-to-Q + board trace delay
set_input_delay -clock Clk -max 2.0 [get_ports Xin[*]]
set_input_delay -clock Clk -min 0.5 [get_ports Xin[*]]

# ------------------------------------------------------------------------------
# 3. Output Delays
# ------------------------------------------------------------------------------
# Assuming external capture register setup/hold requirements + board trace delay
set_output_delay -clock Clk -max 2.0 [get_ports Yout[*]]
set_output_delay -clock Clk -min -0.5 [get_ports Yout[*]]

# ------------------------------------------------------------------------------
# 4. Environmental and Load Constraints
# ------------------------------------------------------------------------------
# Define driving cell for input ports (Replace 'BUFX2' with a cell from your target library)
set_driving_cell -lib_cell BUFX2 [get_ports Xin[*]]

# Define output capacitive load (e.g., 5.0 pF)
set_load 5.0 [get_ports Yout[*]]
