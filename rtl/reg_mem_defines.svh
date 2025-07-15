// This file contains definitions and constants used in the register and memory design.

`define REG_ADDR_WIDTH  8
`define REG_DATA_WIDTH  32
`define MEM_ADDR_WIDTH  16
`define MEM_DATA_WIDTH  32

`define AXI4_ID_WIDTH   4
`define AXI4_ADDR_WIDTH 32
`define AXI4_DATA_WIDTH 32
`define AXI4_STRB_WIDTH (AXI4_DATA_WIDTH/8)

`define AXI4_READ       1'b0
`define AXI4_WRITE      1'b1

`define REG_BASE_ADDR   32'h0000_0000
`define MEM_BASE_ADDR   32'h0000_1000
`define MEM_SIZE        256  // Size of memory in bytes

`define SUCCESS         1
`define FAILURE         0