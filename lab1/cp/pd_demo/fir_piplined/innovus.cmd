#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Wed Sep  9 19:13:34 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v21.15-s110_1 (64bit) 09/23/2022 13:08 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.15-s110_1 NR220912-2004/21_15-UB (database version 18.20.592) {superthreading v2.17}
#@(#)CDS: AAE 21.15-s039 (64bit) 09/23/2022 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.15-s038_1 () Sep 20 2022 11:42:13 ( )
#@(#)CDS: SYNTECH 21.15-s012_1 () Sep  5 2022 10:25:51 ( )
#@(#)CDS: CPE v21.15-s076
#@(#)CDS: IQuantus/TQuantus 21.1.1-s867 (64bit) Sun Jun 26 22:12:54 PDT 2022 (Linux 3.10.0-693.el7.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getVersion
getVersion
getVersion
win
set init_verilog fir_4tap_pipelined_synth.v
set init_top_cell fir_4tap_pipelined
set init_lef_file {/home/install/FOUNDRY/digital/90nm/dig/lef/gsclib090_translated.lef /home/install/FOUNDRY/digital/90nm/dig/lef/gsclib090_macro.lef}
set init_pwr_net VDD
set init_gnd_net VSS
set init_mmmc_file Default.view
init_design
floorPlan -r 1.0 0.7 10.0 10.0 10.0 10.0
globalNetConnect VDD -type pgpin -pin VDD -inst * -module {}
globalNetConnect VSS -type pgpin -pin VSS -inst * -module {}
addRing -nets {VDD VSS} -width 2.0 -spacing 1.0 -layer {top MET3 bottom MET3 left MET2 right MET2}
addStripe -nets {VDD VSS} -layer MET3 -direction vertical -width 1.0 -spacing 2.0 -set_to_set_distance 20
sroute -connect { corePin } -layerChangeRange { MET1 MET3 }
setPlaceMode -fp false
place_opt_design
set_ccopt_property buffer_cells {CLKBUFX2 CLKBUFX3 CLKBUFX4 CLKBUFX6 CLKBUFX8 CLKBUFX12 CLKBUFX16 CLKBUFX20}
set_ccopt_property inverter_cells {CLKINVX1 CLKINVX2 CLKINVX3 CLKINVX4 CLKINVX6 CLKINVX8 CLKINVX12 CLKINVX16 CLKINVX20}
create_ccopt_clock_tree_spec
ccopt_design
