// AXI4 Register Memory Verification Testbench
// File: axi4_reg_mem_tb.sv
// Author: SystemVerilog Verification Team
// Date: July 15, 2025

`include "uvm_macros.svh"
import uvm_pkg::*;

module axi4_reg_mem_tb;

    // Parameters
    localparam CLK_PERIOD = 10; // Clock period in time units

    // Clock and reset signals
    logic clk;
    logic reset;

    // Initialize clock
    initial begin
        clk = 0;
    end

    // AXI4 interface instantiation
    axi4_if axi_interface (
        .clk(clk),
        .reset(reset)
    );

    // DUT instantiation
    Axi4_Reg_Mem dut (
        .clk(clk),
        .reset(reset),
        .axi_if(axi_interface.slave)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Reset generation
    initial begin
        reset = 1;
        #(CLK_PERIOD * 5); // Hold reset for 5 clock cycles
        reset = 0;
        `uvm_info("TB_TOP", "Reset released", UVM_MEDIUM)
    end

    // UVM testbench initialization
    initial begin
        // Set interface in UVM config database
        uvm_config_db#(virtual axi4_if)::set(null, "*", "vif", axi_interface);
        
        // Enable UVM verbosity
        uvm_top.set_report_verbosity_level_hier(UVM_MEDIUM);
        
        // Run UVM test - let command line specify test name
        run_test();
    end

    // Simulation timeout
    initial begin
        #(CLK_PERIOD * 10000); // Run for 10000 clock cycles
        `uvm_info("TB_TOP", "Simulation timeout", UVM_LOW)
        $finish;
    end

    // Waveform dumping - DSIM native .mxd format for better performance
    initial begin
        // DSIM native format dump using -waves command line option
        // The .mxd file will be generated automatically by DSIM
        
        // Generate VCD for compatibility with other tools
        $dumpfile("exec/axi4_reg_mem_waves.vcd");
        $dumpvars(0, axi4_reg_mem_tb);
        
        `uvm_info("TB_TOP", "Waveform dumping enabled: .mxd (via -waves option) and .vcd (compatibility) in exec directory", UVM_LOW)
    end

    // Memory content display task for debugging
    task display_memory_content(input int start_addr, input int end_addr);
        `uvm_info("MEMORY_DUMP", $sformatf("Memory content from 0x%03X to 0x%03X:", start_addr, end_addr), UVM_LOW)
        for (int i = start_addr; i <= end_addr; i += 4) begin
            `uvm_info("MEMORY_DUMP", $sformatf("  [0x%03X] = 0x%08X", i, dut.memory[i>>2]), UVM_LOW)
        end
    endtask

endmodule
