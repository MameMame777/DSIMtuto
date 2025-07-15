# AXI4 Register Memory Module Test Specification

## Document Information

| Field | Value |
|-------|-------|
| Document Title | AXI4 Register Memory Module Test Specification |
| DUT (Device Under Test) | `Axi4_Reg_Mem` |
| File Path | `/rtl/axi4_reg_mem.sv` |
| Interface | `axi4_if.slave` |
| Author | SystemVerilog Verification Team |
| Date | July 15, 2025 |
| Version | 1.0 |

## Overview

### Purpose
This document specifies the comprehensive test requirements for the `Axi4_Reg_Mem` module, which implements a 256x32-bit memory with AXI4 slave interface.

### Scope
- Functional verification of AXI4 protocol compliance
- Memory read/write operations verification
- Reset behavior verification
- Interface timing verification
- Error condition handling

## Design Under Test (DUT) Specification

### Module Interface
```systemverilog
module Axi4_Reg_Mem (
    input logic clk,           // Clock signal
    input logic reset,         // Active high reset
    axi4_if.slave axi_if      // AXI4 slave interface
);
```

### Key Features
- **Memory Size**: 256 words × 32 bits (1024 bytes)
- **Address Range**: 0x000 to 0x3FF (word-aligned)
- **AXI4 Protocol**: Simplified AXI4 slave implementation
- **Response Types**: OKAY (2'b00) only
- **Supported Operations**: Single word read/write transactions

### Memory Map
| Address Range | Description |
|---------------|-------------|
| 0x000 - 0x3FF | General purpose memory |

## Test Categories

### 1. Basic Functionality Tests

#### 1.1 Reset Test
**Objective**: Verify proper reset behavior

**Test Scenarios**:
- **Reset_001**: Power-on reset verification
  - Apply reset during initialization
  - Verify all output signals are in default state
  - Expected: `awready=0`, `wready=0`, `bvalid=0`, `arready=0`, `rvalid=0`

- **Reset_002**: Asynchronous reset during operation
  - Start write/read transaction
  - Apply reset in the middle of transaction
  - Verify immediate reset of all state

#### 1.2 Write Operation Tests
**Objective**: Verify AXI4 write functionality

**Test Scenarios**:
- **Write_001**: Single word write
  - Write data to valid address
  - Verify write handshake sequence
  - Verify memory content update

- **Write_002**: Multiple consecutive writes
  - Write to different addresses sequentially
  - Verify each write completes correctly
  - Verify no data corruption

- **Write_003**: Write with different byte strobes
  - Test `wstrb = 4'hF` (all bytes)
  - Test `wstrb = 4'h3` (lower 2 bytes)
  - Test `wstrb = 4'hC` (upper 2 bytes)
  - Test `wstrb = 4'h1` (byte 0 only)

- **Write_004**: Boundary address testing
  - Write to address 0x000 (first location)
  - Write to address 0x3FC (last valid location)
  - Verify proper address decoding

#### 1.3 Read Operation Tests
**Objective**: Verify AXI4 read functionality

**Test Scenarios**:
- **Read_001**: Single word read
  - Read from previously written address
  - Verify read handshake sequence
  - Verify correct data return

- **Read_002**: Read from uninitialized memory
  - Read from address never written
  - Verify default value (0x00000000)

- **Read_003**: Read after write verification
  - Write known pattern to address
  - Read back from same address
  - Verify data integrity

- **Read_004**: Multiple consecutive reads
  - Read from different addresses sequentially
  - Verify each read completes correctly

### 2. Protocol Compliance Tests

#### 2.1 AXI4 Handshake Tests
**Objective**: Verify proper AXI4 handshake protocol

**Test Scenarios**:
- **Handshake_001**: Write address channel
  - Test `awvalid`/`awready` handshake
  - Verify `awready` assertion timing
  - Verify address capture

- **Handshake_002**: Write data channel
  - Test `wvalid`/`wready` handshake
  - Verify data and strobe capture
  - Verify `wlast` handling

- **Handshake_003**: Write response channel
  - Test `bvalid`/`bready` handshake
  - Verify response timing
  - Verify `bresp` value (OKAY)

- **Handshake_004**: Read address channel
  - Test `arvalid`/`arready` handshake
  - Verify `arready` assertion timing

- **Handshake_005**: Read data channel
  - Test `rvalid`/`rready` handshake
  - Verify data return timing
  - Verify `rresp` value (OKAY)

#### 2.2 Timing Tests
**Objective**: Verify proper timing relationships

**Test Scenarios**:
- **Timing_001**: Back-to-back transactions
  - Perform consecutive write operations
  - Verify no timing violations
  - Verify proper state transitions

- **Timing_002**: Interleaved read/write
  - Alternate between read and write operations
  - Verify proper channel independence

- **Timing_003**: Slow master scenarios
  - Insert wait states in master
  - Verify slave handles delayed responses

### 3. Corner Case Tests

#### 3.1 Edge Address Tests
**Objective**: Test address boundary conditions

**Test Scenarios**:
- **Edge_001**: Address alignment
  - Test word-aligned addresses (0x000, 0x004, 0x008...)
  - Verify proper address decoding

- **Edge_002**: Out-of-range addresses
  - Test addresses beyond memory range (>0x3FC)
  - Verify behavior (implementation-defined)

#### 3.2 Data Pattern Tests
**Objective**: Test various data patterns

**Test Scenarios**:
- **Pattern_001**: All zeros (0x00000000)
- **Pattern_002**: All ones (0xFFFFFFFF)
- **Pattern_003**: Alternating pattern (0xAAAAAAAA, 0x55555555)
- **Pattern_004**: Walking ones (0x00000001, 0x00000002, 0x00000004...)
- **Pattern_005**: Random data patterns

### 4. Stress Tests

#### 4.1 Performance Tests
**Objective**: Verify sustained operation

**Test Scenarios**:
- **Stress_001**: Continuous write operations
  - Fill entire memory with known pattern
  - Verify no data corruption

- **Stress_002**: Continuous read operations
  - Read entire memory sequentially
  - Verify consistent data return

- **Stress_003**: Mixed read/write stress
  - Random sequence of reads and writes
  - Verify data integrity throughout

## Test Implementation Strategy

### 1. Testbench Architecture
```
axi4_system_tb
├── Clock/Reset Generator
├── AXI4 Master BFM (Bus Functional Model)
├── DUT (Axi4_Reg_Mem)
├── Monitor/Checker
└── Coverage Collector
```

### 2. Test Files Structure
```
tb/
├── tests/
│   ├── axi4_basic_test.sv      - Basic functionality
│   ├── axi4_protocol_test.sv   - Protocol compliance
│   ├── axi4_corner_test.sv     - Corner cases
│   └── axi4_stress_test.sv     - Stress testing
├── sequences/
│   ├── axi4_write_seq.sv       - Write sequences
│   ├── axi4_read_seq.sv        - Read sequences
│   └── axi4_mixed_seq.sv       - Mixed operations
└── checkers/
    ├── axi4_protocol_checker.sv - Protocol assertions
    └── axi4_memory_checker.sv   - Memory model
```

### 3. Verification Environment
- **UVM-based testbench** for advanced verification
- **SystemVerilog Assertions (SVA)** for protocol checking
- **Functional coverage** for completeness tracking
- **Constrained random testing** for corner case discovery

## Success Criteria

### Functional Requirements
- ✅ All write operations complete successfully
- ✅ All read operations return correct data
- ✅ Reset behavior is correct
- ✅ AXI4 protocol compliance verified

### Coverage Requirements
- **Functional Coverage**: ≥ 95%
  - Address coverage (all memory locations)
  - Data pattern coverage
  - Byte strobe combinations
- **Code Coverage**: ≥ 100%
  - Line coverage
  - Branch coverage
  - Toggle coverage

### Performance Requirements
- **Latency**: Single cycle response for ready signals
- **Throughput**: One transaction per clock cycle capability

## Test Environment Setup

### Required Tools
- **Simulator**: Metrics DSim
- **Language**: SystemVerilog with UVM
- **Waveform Viewer**: For debug analysis
- **Coverage Tools**: Built-in coverage collection

### Execution Commands
```bash
# Basic functionality test
dsim -uvm 1.2 <files> +UVM_TESTNAME=axi4_basic_test

# Protocol compliance test  
dsim -uvm 1.2 <files> +UVM_TESTNAME=axi4_protocol_test

# Stress test
dsim -uvm 1.2 <files> +UVM_TESTNAME=axi4_stress_test
```

## Expected Results

### Pass Criteria
1. All test scenarios pass without errors
2. No protocol violations detected
3. Memory integrity maintained throughout testing
4. Coverage goals achieved

### Failure Analysis
- **Protocol violations**: Check AXI4 signal timing
- **Data mismatches**: Verify write/read data paths
- **Timeout errors**: Check handshake completion
- **Reset issues**: Verify asynchronous reset behavior

## Appendices

### A. AXI4 Protocol References
- ARM AMBA AXI4 Protocol Specification
- Verification IP documentation

### B. Memory Model
- Internal memory array: `logic [31:0] memory [0:255]`
- Address mapping: `addr[7:0]` for word selection
- Byte strobe handling: Full word writes only in current implementation

### C. Known Limitations
- Single outstanding transaction only
- No burst support implemented
- No protection/security features
- Limited error response handling

---

**Document Control**
- **Created**: July 15, 2025
- **Last Modified**: July 15, 2025
- **Review Status**: Draft
- **Approved By**: [To be assigned]
