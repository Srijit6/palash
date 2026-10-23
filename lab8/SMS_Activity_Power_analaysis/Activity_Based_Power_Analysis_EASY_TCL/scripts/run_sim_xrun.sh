#!/bin/sh
set -e

# Run from scripts folder: cd scripts
mkdir -p ../vcd

for CASE in clk_low clk_high data_low data_high
do
  echo "=== Xcelium simulation: ${CASE} ==="
  rm -f ${CASE}.vcd
  xrun -64bit -access +rwc ../RTL/activity_power_top.v ../TB/tb_${CASE}.v
  mv ${CASE}.vcd ../vcd/${CASE}.vcd
done

echo "All VCD files generated in ../vcd/"
