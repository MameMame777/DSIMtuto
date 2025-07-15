// Simple Testbench without UVM
// File: simple_tb_top.sv
// Author: SystemVerilog Testbench
// Date: July 15, 2025

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
        $display("Reset released at time %0t", $time);
    end

    // Simple test sequence
    initial begin
        // Wait for reset deassertion
        wait(!reset);
        repeat(10) @(posedge clk);
        
        $display("Simple test completed successfully at time %0t", $time);
        $finish;
    end

    // Simulation timeout
    initial begin
        #(CLK_PERIOD * 1000); // Run for 1000 clock cycles
        $display("Simulation timeout at time %0t", $time);
        $finish;
    end

    // Waveform dumping
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_top);
    end

endmodule
