
set TOP_MODULE "fir_4tap"

set_db init_lib_search_path /home/install/FOUNDRY/digital/90nm/dig/lib
#set_db init_hdl_search_path /home/Sakthivel/lab5/fir


read_libs slow.lib
read_hdl {DFF.v fir_4tap.v}
elaborate 
read_sdc fir_4tap.sdc

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium
syn_generic
write_hdl > output/netlist/${TOP_MODULE}_genric.v
syn_map
write_hdl > output/netlist/${TOP_MODULE}_mapped.v
syn_opt
write_hdl > output/netlist/${TOP_MODULE}_opt.v

write_sdc > output/constrints/${TOP_MODULE}_synth.sdc

report_timing > output/reports/${TOP_MODULE}_timing.rpt
report_power > output/reports/${TOP_MODULE}_power.rpt
report_area > output/reports/${TOP_MODULE}_area.rpt
report_gates > output/reports/${TOP_MODULE}_gates.rpt
report_qor > output/reports/${TOP_MODULE}_qor.rpt

gui_show
