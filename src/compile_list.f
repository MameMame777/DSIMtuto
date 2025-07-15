# compile_list.f

# List of files to be compiled for the AXI4 verification project
# Note: Interface definitions must come before modules that use them

# Interface definitions (RTL)
../rtl/interfaces/axi4_if.sv

# RTL files  
../rtl/axi4_reg_mem.sv
../rtl/reg_mem_defines.svh

# Testbench interface definitions
../tb/interfaces/axi4_interface.sv

# Basic testbench files
../tb/axi4_transaction.sv
../tb/tb_pkg.sv
../tb/top/tb_top.sv
../tb/top/simple_tb_top.sv
../tb/top/axi4_system_tb.sv

# UVM components
tb/uvm/agents/axi4_agent/axi4_agent_pkg.sv
tb/uvm/agents/axi4_agent/axi4_agent.sv
tb/uvm/agents/axi4_agent/axi4_driver.sv
tb/uvm/agents/axi4_agent/axi4_monitor.sv
tb/uvm/agents/axi4_agent/axi4_sequencer.sv
tb/uvm/env/axi4_env_pkg.sv
tb/uvm/env/axi4_env.sv
tb/uvm/env/axi4_scoreboard.sv
tb/uvm/sequences/axi4_seq_pkg.sv
tb/uvm/sequences/axi4_base_seq.sv
tb/uvm/sequences/axi4_read_seq.sv
tb/uvm/sequences/axi4_write_seq.sv
tb/uvm/tests/axi4_test_pkg.sv
tb/uvm/tests/axi4_base_test.sv
tb/uvm/tests/axi4_smoke_test.sv