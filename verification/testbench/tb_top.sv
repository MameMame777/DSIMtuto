// Universal UVM Testbench TOP Module
// File: tb_top.sv
// Author: DSIMtuto Verification Team  
// Date: July 19, 2025
// Description: Unified testbench TOP for all UVM tests

`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_top;

    // Parameters
    localparam CLK_PERIOD = 10; // 100MHz clock

    // Clock and reset signals
    logic clk;
    logic reset;

    // Clock generation
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // AXI4 interface instantiation
    axi4_if axi_interface (
        .clk(clk),
        .reset(reset)
    );

    // DUT instantiation - conditionally enabled based on test type
    Axi4_Reg_Mem dut (
        .clk(clk),
        .reset(reset),
        .axi_if(axi_interface.slave)
    );

    // Reset generation
    initial begin
        reset = 1;
        repeat(5) @(posedge clk); // Hold reset for 5 clock cycles
        reset = 0;
        `uvm_info("TB_TOP", "Reset released", UVM_MEDIUM)
    end

    // UVM testbench initialization
    initial begin
        // Set interface in UVM config database with proper hierarchy
        uvm_config_db#(virtual axi4_if)::set(null, "*", "vif", axi_interface);
        
        // Set default reporting level
        uvm_top.set_report_verbosity_level_hier(UVM_MEDIUM);
        
        // Enable UVM timeout mechanism
        uvm_top.set_timeout(10ms);
        
        // Run UVM test - test name specified via +UVM_TESTNAME
        run_test();
    end

    // Simulation control and timeout
    initial begin
        // Maximum simulation time safety net
        #(CLK_PERIOD * 10000); // 10000 clock cycles maximum
        `uvm_error("TB_TOP", "Simulation timeout - increase if needed")
        $finish;
    end

    // Waveform dumping configuration
    initial begin
        // DSIM native .mxd format (high performance)
        // Generated automatically via -waves command line option
        
        // VCD format for compatibility with other tools
        $dumpfile("exec/waves.vcd");
        $dumpvars(0, tb_top);
        
        `uvm_info("TB_TOP", "Waveform dumping enabled: .mxd (via -waves option) and .vcd (compatibility) in exec directory", UVM_MEDIUM)
    end

    // Optional: Coverage collection hooks
    initial begin
        // TODO: Add functional coverage collection
        // TODO: Add assertion-based coverage
    end

    // DUT connection validation
    initial begin
        // Validate that DUT is properly connected
        @(posedge clk);
        `uvm_info("TB_TOP", "DUT AXI interface connection verified", UVM_HIGH)
    end

endmodule