`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_top;

    // Parameters
    localparam CLK_PERIOD = 10; // Clock period in time units

    // DUT (Device Under Test) signals
    logic clk;
    logic reset;

    // Initialize clock
    initial begin
        clk = 0;
    end

    // AXI4 interface instantiation
    axi4_if axi4_interface (
        .clk(clk),
        .reset(reset)
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
        uvm_config_db#(virtual axi4_if)::set(null, "*", "vif", axi4_interface);
        
        // Enable UVM verbosity
        uvm_top.set_report_verbosity_level_hier(UVM_MEDIUM);
        
        // Run UVM test - let command line specify test name
        run_test();
    end

    // Simulation timeout
    initial begin
        #(CLK_PERIOD * 1000); // Run for 1000 clock cycles
        `uvm_info("TB_TOP", "Simulation timeout", UVM_LOW)
        $finish;
    end

    // Waveform dumping
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_top);
    end

endmodule