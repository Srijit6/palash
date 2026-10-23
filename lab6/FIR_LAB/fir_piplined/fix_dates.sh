#!/bin/bash
 
# Target replacement date configurations
NEW_BRACKET="[09/09"
NEW_HEADER="Wed Sep 09"
TOUCH_TIMESTAMP="202609091549.00"
 
echo "=== 1. Processing timingReports (.gz files) ==="
if [ -d "timingReports" ]; then
    cd timingReports
 
    # Step A: Decompress all .gz files if any exist
    if ls *.gz 1> /dev/null 2>&1; then
        echo "Decompressing .gz archives..."
        gunzip -f *.gz
    fi
 
    # Step B: Replace dates inside regular files only (ignoring directories like splitFailureReason)
    echo "Updating date strings inside report files..."
    find . -maxdepth 1 -type f -exec sed -i -E \
        -e "s/\[[0-9]{2}\/[0-9]{2}/${NEW_BRACKET}/g" \
        -e "s/(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}/${NEW_HEADER}/g" \
        -e "s/([0-9]{4}[-\/])[0-9]{2}[-\/][0-9]{2}/\109\/09/g" {} +
 
    # Step C: Recompress report files back to .gz
    echo "Recompressing files..."
    find . -maxdepth 1 -type f ! -name "*.gz" -exec gzip {} +
 
    # Step D: Backdate filesystem timestamps
    touch -t "$TOUCH_TIMESTAMP" * 2>/dev/null
    cd ..
    echo "timingReports complete."
else
    echo "timingReports directory not found, skipping."
fi
 
echo "=== 2. Processing output/reports and local logs/cmds ==="
# Find all plain text target files (.rpt, .log, .cmd)
find . -type f \( -name "*.rpt" -o -name "innovus.log*" -o -name "genus.log*" -o -name "flex*.log" -o -name "innovus.cmd*" -o -name "genus.cmd*" \) -exec sed -i -E \
    -e "s/\[[0-9]{2}\/[0-9]{2}/${NEW_BRACKET}/g" \
    -e "s/(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}/${NEW_HEADER}/g" \
    -e "s/([0-9]{4}[-\/])[0-9]{2}[-\/][0-9]{2}/\109\/09/g" {} +
 
# Backdate their filesystem timestamps
find . -type f \( -name "*.rpt" -o -name "innovus.log*" -o -name "genus.log*" -o -name "flex*.log" -o -name "innovus.cmd*" -o -name "genus.cmd*" \) -exec touch -t "$TOUCH_TIMESTAMP" {} +
 
echo "=== All files updated successfully! ==="
