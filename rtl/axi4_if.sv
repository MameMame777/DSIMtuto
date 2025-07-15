module axi4_if (
    input logic         clk,
    input logic         resetn,

    // AXI4 Write Address Channel
    input logic [31:0]  awaddr,
    input logic [7:0]   awlen,
    input logic         awvalid,
    output logic        awready,

    // AXI4 Write Data Channel
    input logic [31:0]  wdata,
    input logic [3:0]   wstrb,
    input logic         wvalid,
    output logic        wready,

    // AXI4 Write Response Channel
    output logic [1:0]  bresp,
    output logic        bvalid,
    input logic         bready,

    // AXI4 Read Address Channel
    input logic [31:0]  araddr,
    input logic [7:0]   arlen,
    input logic         arvalid,
    output logic        arready,

    // AXI4 Read Data Channel
    output logic [31:0] rdata,
    output logic [1:0]  rresp,
    output logic        rvalid,
    input logic         rready
);

    // AXI4 interface implementation goes here

endmodule