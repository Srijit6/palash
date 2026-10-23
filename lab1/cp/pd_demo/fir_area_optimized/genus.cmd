# Cadence Genus(TM) Synthesis Solution, Version 21.14-s082_1, built Jun 23 2022 14:32:08

# Date: Wed Sep 09 18:01:48 2026
# Host: cad312vitcc.vit.ac.in (x86_64 w/Linux 4.18.0-553.150.1.el8_10.x86_64) (16cores*64cpus*2physical cpus*INTEL(R) XEON(R) GOLD 6526Y 38400KB)
# OS:   Red Hat Enterprise Linux release 8.10 (Ootpa)

set_db / .library {../../../install/FOUNDRY/digital/90nm/dig/lib/slow.lib}
read_hdl fir_4tap_shared_mult.v
elaborate fir_4tap_shared_mult
read_sdc fir_4tap_shared_mult.sdc
syn_generic
syn_map
syn_opt
write_hdl > fir_4tap_shared_mult_synth.v
write_sdc > fir_4tap_shared_mult_synth.sdc
