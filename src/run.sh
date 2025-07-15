#!/bin/bash

# This script is used to run the simulation for the AXI4 verification project.

# Set the simulator executable
SIMULATOR="dvsim"  # Replace with the actual DSIM simulator command if different

# Set the compilation options
COMPILE_OPTIONS="-sv -g2012"

# Set the file list for compilation
FILE_LIST="../src/compile_list.f"

# Compile the design and testbench
echo "Compiling the design and testbench..."
$SIMULATOR $COMPILE_OPTIONS -f $FILE_LIST

# Run the simulation
echo "Running the simulation..."
$SIMULATOR -l simulation.log -sv -top tb.tb_top

# Check for errors
if [ $? -ne 0 ]; then
    echo "Simulation failed. Check simulation.log for details."
    exit 1
fi

echo "Simulation completed successfully."