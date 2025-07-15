// Top-level testbench with AXI4 interface integration
// File: axi4_system_tb.sv
// Author: SystemVerilog Testbench
// Date: July 15, 2025

module axi4_system_tb;

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
        $display("[%0t] Reset released", $time);
    end

    // Simple test sequence
    initial begin
        // Wait for reset deassertion
        wait(!reset);
        repeat(2) @(posedge clk);
        
        $display("[%0t] Starting AXI4 test sequence", $time);
        
        // Test write operation
        test_write_operation(32'h00000004, 32'hDEADBEEF);
        
        // Test read operation
        test_read_operation(32'h00000004);
        
        // Wait and finish
        repeat(10) @(posedge clk);
        $display("[%0t] Test completed successfully", $time);
        $finish;
    end

    // Write operation task
    task test_write_operation(input [31:0] addr, input [31:0] data);
        begin
            @(posedge clk);
            // Set write address
            axi_interface.awaddr = addr;
            axi_interface.awvalid = 1'b1;
            axi_interface.awlen = 8'h00;   // Single transfer
            axi_interface.awsize = 3'b010; // 32-bit transfer
            axi_interface.awburst = 2'b01; // INCR burst
            
            // Set write data
            axi_interface.wdata = data;
            axi_interface.wstrb = 4'hF;    // All bytes valid
            axi_interface.wvalid = 1'b1;
            axi_interface.wlast = 1'b1;    // Last transfer
            
            // Set response ready
            axi_interface.bready = 1'b1;
            
            // Wait for handshakes
            wait(axi_interface.awready);
            @(posedge clk);
            axi_interface.awvalid = 1'b0;
            
            wait(axi_interface.wready);
            @(posedge clk);
            axi_interface.wvalid = 1'b0;
            
            wait(axi_interface.bvalid);
            @(posedge clk);
            axi_interface.bready = 1'b0;
            
            $display("[%0t] Write completed: addr=0x%08h, data=0x%08h", $time, addr, data);
        end
    endtask

    // Read operation task
    task test_read_operation(input [31:0] addr);
        logic [31:0] read_data;
        begin
            @(posedge clk);
            // Set read address
            axi_interface.araddr = addr;
            axi_interface.arvalid = 1'b1;
            axi_interface.arlen = 8'h00;   // Single transfer
            axi_interface.arsize = 3'b010; // 32-bit transfer
            axi_interface.arburst = 2'b01; // INCR burst
            
            // Set read ready
            axi_interface.rready = 1'b1;
            
            // Wait for address handshake
            wait(axi_interface.arready);
            @(posedge clk);
            axi_interface.arvalid = 1'b0;
            
            // Wait for data response
            wait(axi_interface.rvalid);
            read_data = axi_interface.rdata;
            @(posedge clk);
            axi_interface.rready = 1'b0;
            
            $display("[%0t] Read completed: addr=0x%08h, data=0x%08h", $time, addr, read_data);
        end
    endtask

    // Simulation timeout
    initial begin
        #(CLK_PERIOD * 1000); // Run for 1000 clock cycles
        $display("[%0t] Simulation timeout", $time);
        $finish;
    end

    // Waveform dumping
    initial begin
        $dumpfile("axi4_system_waves.vcd");
        $dumpvars(0, axi4_system_tb);
    end

endmodule
