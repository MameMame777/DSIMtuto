# Makefile for UVM AXI4 Verification Project

# This Makefile is used to compile the RTL and testbench files for the UVM AXI4 verification project.

# Define the simulator
SIMULATOR = dsim

# Define the source directories
RTL_DIR = ../rtl
TB_DIR = ../tb
SRC_DIR = .

# Define the output directory for simulation results
OUTPUT_DIR = ../sim

# Define the list of files to compile
COMPILE_FILES = $(shell cat compile_list.f)

# Define the simulation executable name
SIM_EXEC = simv

# Default target
all: compile run

# Compile the design and testbench files
compile:
	$(SIMULATOR) -f $(SRC_DIR)/compile_list.f -o $(OUTPUT_DIR)/$(SIM_EXEC)

# Run the simulation
run:
	$(OUTPUT_DIR)/$(SIM_EXEC)

# Clean up generated files
clean:
	rm -rf $(OUTPUT_DIR)/$(SIM_EXEC) $(OUTPUT_DIR)/waves/*

.PHONY: all compile run clean