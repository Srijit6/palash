# 1. Design Import
source design_setup.globals
init_design

# 2. Floorplanning & Power Planning
floorPlan -r 1.0 0.7 10.0 10.0 10.0 10.0
globalNetConnect VDD -type pgpin -pin VDD -inst * -module {}
globalNetConnect VSS -type pgpin -pin VSS -inst * -module {}
addRing -nets {VDD VSS} -width 2.0 -spacing 1.0 -layer {top MET3 bottom MET3 left MET2 right MET2}
addStripe -nets {VDD VSS} -layer MET3 -direction vertical -width 1.0 -spacing 2.0 -set_to_set_distance 20
sroute -connect { corePin } -layerChangeRange { MET1 MET3 }

# 3. Placement
setPlaceMode -fp false
place_opt_design

# 4. Clock Tree Synthesis
create_ccopt_clock_tree_spec
ccopt_design

# 5. Routing
setNanoRouteMode -quiet -routeInsertAntennaDiode true
setNanoRouteMode -quiet -routeWithTimingDriven true
routeDesign -globalDetail

# 6. Post-Route Optimization
setExtractRCMode -engine postRoute -effort level3
optDesign -postRoute -setup
optDesign -postRoute -hold

# 7. Verification and Reports
verifyGeometry
verifyConnectivity -type all
report_area 
report_power 
report_timing -path_type full_clock -max_paths 10
