// This file implements the register and memory read/write circuit using the AXI4 interface.

module Axi4_Reg_Mem (
    input logic clk,
    input logic reset,
    axi4_if.slave axi_if
);

    // Internal signals to avoid modport read warnings
    logic        awvalid_int, awready_int;
    logic        wvalid_int, wready_int;  
    logic        bvalid_int, bready_int;
    logic        arvalid_int, arready_int;
    logic        rvalid_int, rready_int;
    logic [31:0] awaddr_int, wdata_int, araddr_int, rdata_int;
    logic [3:0]  wstrb_int;
    logic [1:0]  bresp_int, rresp_int;

    // Connect interface signals to internal signals
    assign awvalid_int = axi_if.awvalid;
    assign axi_if.awready = awready_int;
    assign awaddr_int = axi_if.awaddr;
    
    assign wvalid_int = axi_if.wvalid;
    assign axi_if.wready = wready_int;
    assign wdata_int = axi_if.wdata;
    assign wstrb_int = axi_if.wstrb;
    
    assign axi_if.bvalid = bvalid_int;
    assign bready_int = axi_if.bready;
    assign axi_if.bresp = bresp_int;
    
    assign arvalid_int = axi_if.arvalid;
    assign axi_if.arready = arready_int;
    assign araddr_int = axi_if.araddr;
    
    assign axi_if.rvalid = rvalid_int;
    assign rready_int = axi_if.rready;
    assign axi_if.rdata = rdata_int;
    assign axi_if.rresp = rresp_int;

    // Memory array
    logic [31:0] memory [0:255]; // 256 x 32-bit memory

    // Initialize memory to zero
    initial begin
        for (int i = 0; i < 256; i++) begin
            memory[i] = 32'h0;
        end
    end

    // Write address handshake - Proper AXI4 protocol
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            awready_int <= 1'b0; // Reset to not ready (AXI4 compliant)
        end else begin
            awready_int <= 1'b1; // Always ready to accept address after reset
        end
    end

    // Write data handshake - Proper AXI4 protocol
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            wready_int <= 1'b0;  // Reset to not ready (AXI4 compliant)
            bvalid_int <= 1'b0;
            bresp_int <= 2'b00; // OKAY response
        end else begin
            // Always ready to accept write data after reset
            wready_int <= 1'b1;
            
            // Write to memory when both address and data are valid
            if (awvalid_int && wvalid_int && awready_int && wready_int) begin
                memory[awaddr_int[7:0]] <= wdata_int; // Write data to memory
                bvalid_int <= 1'b1; // Indicate write response valid
                bresp_int <= 2'b00; // OKAY response
            end else if (bready_int && bvalid_int) begin
                bvalid_int <= 1'b0; // Clear write response valid
            end
        end
    end

    // Read address handshake - Proper AXI4 protocol
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            arready_int <= 1'b0; // Reset to not ready (AXI4 compliant)
        end else begin
            arready_int <= 1'b1; // Always ready to accept address after reset
        end
    end

    // Read data response - Fixed timing
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            rvalid_int <= 1'b0;
            rdata_int <= 32'b0;
            rresp_int <= 2'b00; // OKAY response
        end else begin
            if (arvalid_int && arready_int && !rvalid_int) begin
                rdata_int <= memory[araddr_int[7:0]]; // Read data from memory
                rvalid_int <= 1'b1; // Indicate read response valid
                rresp_int <= 2'b00; // OKAY response
            end else if (rready_int && rvalid_int) begin
                rvalid_int <= 1'b0; // Clear read response valid
            end
        end
    end

endmodule