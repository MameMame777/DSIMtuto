// AXI4 Interface Definition for Testbench
// File: axi4_interface.sv
// Author: SystemVerilog Testbench
// Date: July 15, 2025

interface axi4_if (
    input logic clk,
    input logic reset
);

    // AXI4 Write Address Channel
    logic        awvalid;
    logic        awready;
    logic [31:0] awaddr;
    logic [7:0]  awlen;
    logic [2:0]  awsize;
    logic [1:0]  awburst;
    logic [3:0]  awid;

    // AXI4 Write Data Channel
    logic        wvalid;
    logic        wready;
    logic [31:0] wdata;
    logic [3:0]  wstrb;
    logic        wlast;

    // AXI4 Write Response Channel
    logic        bvalid;
    logic        bready;
    logic [1:0]  bresp;
    logic [3:0]  bid;

    // AXI4 Read Address Channel
    logic        arvalid;
    logic        arready;
    logic [31:0] araddr;
    logic [7:0]  arlen;
    logic [2:0]  arsize;
    logic [1:0]  arburst;
    logic [3:0]  arid;

    // AXI4 Read Data Channel
    logic        rvalid;
    logic        rready;
    logic [31:0] rdata;
    logic [1:0]  rresp;
    logic        rlast;
    logic [3:0]  rid;

    // Modport for master
    modport master (
        output awvalid, awaddr, awlen, awsize, awburst, awid,
        input  awready,
        output wvalid, wdata, wstrb, wlast,
        input  wready,
        input  bvalid, bresp, bid,
        output bready,
        output arvalid, araddr, arlen, arsize, arburst, arid,
        input  arready,
        input  rvalid, rdata, rresp, rlast, rid,
        output rready
    );

    // Modport for slave
    modport slave (
        input  awvalid, awaddr, awlen, awsize, awburst, awid,
        output awready,
        input  wvalid, wdata, wstrb, wlast,
        output wready,
        output bvalid, bresp, bid,
        input  bready,
        input  arvalid, araddr, arlen, arsize, arburst, arid,
        output arready,
        output rvalid, rdata, rresp, rlast, rid,
        input  rready
    );

endinterface
