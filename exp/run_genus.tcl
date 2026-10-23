# 1. Setup Libraries (Using the 90nm FOUNDRY paths)
set_db library /home/install/FOUNDRY/digital/90nm/dig/lib/slow.lib
set_db lef_library /home/install/FOUNDRY/digital/90nm/dig/lef/gsclib090_translated.lef

# 2. Read and Elaborate RTL
read_hdl exp.v
elaborate exp
check_design -unresolved

# 3. Apply Basic Constraints (Combinational)
# Setting a virtual clock to constrain the input-to-output paths
create_clock -name v_clk -period 10.0
set_input_delay  -clock v_clk 2.0 [all_inputs]
set_output_delay -clock v_clk 2.0 [all_outputs]

# 4. Synthesis
syn_generic
syn_map
syn_opt

# 5. Generate Reports
exec mkdir -p reports
report_timing > reports/timing.rpt
report_area   > reports/area.rpt
report_power  > reports/power.rpt

# 6. Export Outputs for Innovus
exec mkdir -p outputs
write_hdl > outputs/exp_netlist.v
write_sdc > outputs/exp_constraints.sdc

puts "Synthesis Complete. Netlist saved to outputs/exp_netlist.v"
quit
