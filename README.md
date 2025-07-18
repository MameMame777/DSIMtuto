# DSIMtuto - UVM-AXI4 Verification Project

## Overview

This project is designed to facilitate the understanding and implementation of the Universal Verification Methodology (UVM) using the DSIM simulator. The focus is on verifying an RTL design that implements a register and memory read/write circuit utilizing the AXI4 interface.

**Key Features:**

- ✅ **Unified Test Execution System**: Configuration-driven test management
- ✅ **Comprehensive UVM Verification**: Multiple test scenarios with full coverage
- ✅ **AXI4 Protocol Implementation**: Complete interface and register memory module
- ✅ **Automated Environment Setup**: DSIM simulator with UVM-1.2 integration
- ✅ **Scalable Test Framework**: Easy addition of new test configurations

## AXI4 Specification

<https://developer.arm.com/documentation/ihi0022/latest>

## UVM Introduction

<https://www.accellera.org/images/downloads/standards/uvm/uvm_users_guide_1.2.pdf>

## UVM Verification Environment

For detailed information about the UVM verification environment, class structure, and test flows, see:
📖 **[UVM Verification Environment Guide](docs/uvm_verification_guide.md)**

This guide covers:

- UVM class hierarchy and architecture
- Test layer implementation details
- Verification scenarios and test flows
- Scoreboard implementation
- Best practices and file organization

## Project Structure
The project is organized into several directories, each serving a specific purpose:

- **rtl/**: Contains the RTL design files.
  - **interfaces/**: Interface definitions
    - `axi4_if.sv`: Defines the AXI4 interface module.
    - `axi4_interface.sv`: Alternative AXI4 interface implementation.
  - `axi4_reg_mem.sv`: Implements the register and memory read/write circuit.
  - `reg_mem_defines.svh`: Contains definitions and constants for the design.

- **verification/**: Contains the verification environment.
  - **common/**: Common test files and transaction definitions
    - `axi4_transaction.sv`: Defines the AXI4 transaction class.
    - `axi4_base_test.sv`: Defines the base test class.
    - `axi4_reg_mem_basic_test.sv`: Basic register memory test implementation.
  - **testbench/**: Top-level testbench files
    - `tb_top.sv`: Instantiates the DUT and UVM components.
    - `axi4_system_tb.sv`: System-level testbench.
    - `axi4_reg_mem_tb.sv`: Register memory testbench.
    - `simple_tb_top.sv`: Simple testbench implementation.
  - **uvm/**: Contains UVM components.
    - `tb_pkg.sv`: Packages the testbench components.
    - **agents/**: Contains the AXI4 agent components.
      - `axi4_agent.sv`: Defines the AXI4 agent class.
      - `axi4_driver.sv`: Implements the AXI4 driver class.
      - `axi4_monitor.sv`: Implements the AXI4 monitor class.
      - `axi4_sequencer.sv`: Defines the AXI4 sequencer class.
      - `axi4_agent_pkg.sv`: Packages the AXI4 agent components.
    - **env/**: Contains the AXI4 environment components.
      - `axi4_env.sv`: Defines the AXI4 environment class.
      - `axi4_scoreboard.sv`: Implements the AXI4 scoreboard class.
      - `axi4_env_pkg.sv`: Packages the AXI4 environment components.
    - **sequences/**: Contains the AXI4 sequence components.
      - `axi4_base_seq.sv`: Defines the base sequence class.
      - `axi4_read_seq.sv`: Implements a read transaction sequence.
      - `axi4_write_seq.sv`: Implements a write transaction sequence.
      - `axi4_seq_pkg.sv`: Packages the AXI4 sequence components.
    - **tests/**: Contains the AXI4 test components.
      - `axi4_base_test.sv`: Defines the base test class.
      - `axi4_smoke_test.sv`: Implements a simple smoke test.
      - `axi4_test_pkg.sv`: Packages the AXI4 test components.

- **sim/**: Contains simulation management system.
  - **run/**: Execution scripts
    - `run.bat`: **Main unified test execution script** - Configuration-driven test management
    - `run_axi4_system.bat`: Legacy AXI4 system test script
    - `run_reg_mem_test.bat`: Legacy register memory test script
    - `run_uvm.bat`: Legacy UVM test script
    - `run_simple.bat`: Legacy simple testbench script
  - **config/**: Configuration files
    - `test_config.cfg`: **Test configuration file** - Centralized test definitions
    - **filelists/**: **Source file lists** - Modular file management for each test
      - `axi4_reg_mem.f`: AXI4 register memory test files
      - `axi4_system.f`: AXI4 system integration test files  
      - `uvm_base.f`: UVM base framework test files
      - `simple.f`: Simple testbench files
      - `axi4_advanced.f`: Advanced test configuration template
  - **output/**: Simulation output files
    - Waveform files (*.vcd, *.mxd)
    - Log files (*.log)
    - Compilation results (dsim_work/)

- **tools/**: Contains utility scripts and tools.

- **docs/**: Contains documentation files.
  - `axi4_spec.md`: Specifications for the AXI4 protocol.
  - `uvm_guide.md`: Guide to understanding UVM.
  - `uvm_verification_guide.md`: Comprehensive UVM verification environment guide.

- **diary/**: Contains documentation of insights and findings.
  - `week1.md`: Insights from the verification process during the first week.

- **.github/**: Contains GitHub Actions CI/CD configuration.
  - **workflows/**: Automated testing workflows
    - `ci.yml`: Continuous integration pipeline

## Getting Started

### Prerequisites
- **Metrics DSIM Simulator**: Version 20240422.0.0 or later
- **UVM Library**: Version 1.2 (included with DSIM)
- **Operating System**: Windows with PowerShell
- **DSIM License**: Valid license file required

### Quick Start - Unified Test Execution System

Navigate to the `sim/run` directory and use the unified test execution system:

```bash
cd sim/run

# Show all available test configurations
.\run.bat

# Execute a specific test
.\run.bat [TEST_NAME]
```

**Alternative: Execute from project root**

```bash
# From project root directory (DSIMtuto/)
.\run.bat [TEST_NAME]
```

### Available Test Configurations

| Test Name | Type | Description | UVM Verbosity |
|-----------|------|-------------|---------------|
| `axi4_reg_mem_basic` | UVM | **AXI4 Register Memory Basic Test** - Comprehensive verification with 6 test scenarios | UVM_MEDIUM |
| `axi4_system` | Non-UVM | **AXI4 System Integration Test** - System-level integration testing | N/A |
| `uvm_base` | UVM | **UVM Base Framework Test** - UVM framework functionality verification | UVM_MEDIUM |
| `simple_tb` | Non-UVM | **Simple Testbench** - Basic SystemVerilog testbench | N/A |
| `axi4_advanced` | UVM | **AXI4 Advanced Features Test** - Template for advanced protocol testing | UVM_HIGH |

### Execution Examples

#### 1. AXI4 Register Memory Verification (Recommended Starting Point)

```bash
.\run.bat axi4_reg_mem_basic
```

**Test Coverage:**

- Reset behavior verification
- Basic write/read operations  
- Write-read round-trip verification
- Multiple address testing (5 addresses)
- Data pattern testing (5 patterns)

**Expected Results:**

- ✅ 29 UVM_INFO messages
- ✅ 0 UVM_ERROR messages  
- ✅ Waveform: `sim/output/axi4_reg_mem_waves.vcd`
- ✅ All 6 test scenarios PASSED

#### 2. System Integration Testing

```bash
.\run.bat axi4_system
```

#### 3. UVM Framework Testing

```bash
.\run.bat uvm_base
```

### Understanding Test Results

#### Successful Test Execution
```
================================================================================
Test 'axi4_reg_mem_basic' completed successfully!
Waveform saved to: axi4_reg_mem_waves.vcd
================================================================================
```

#### UVM Report Summary (Success Indicators)
```
--- UVM Report Summary ---
** Report counts by severity
UVM_INFO :   29
UVM_WARNING :    0
UVM_ERROR :    0      ← Must be 0
UVM_FATAL :    0      ← Must be 0
```

### Adding New Tests

#### Step 1: Create Filelist

Create `sim/config/filelists/my_new_test.f`:

```systemverilog
# My New Test Filelist
..\..\rtl\my_module.sv
..\..\verification\my_test.sv
..\..\verification\testbench\my_tb_top.sv
```

#### Step 2: Add Configuration Entry

Edit `sim/config/test_config.cfg`:

```cfg
my_new_test|My New Test Description|filelists/my_new_test.f|My_Test_Class|my_test_waves.vcd|UVM_MEDIUM
```

#### Step 3: Execute New Test

```bash
.\run.bat my_new_test
```

### Legacy Compatibility

Individual scripts are maintained for backward compatibility:

| Legacy Script | Equivalent Unified Command | Location |
|---------------|---------------------------|----------|
| `run_reg_mem_test.bat` | `.\run.bat axi4_reg_mem_basic` | `sim/run/` |
| `run_axi4_system.bat` | `.\run.bat axi4_system` | `sim/run/` |
| `run_uvm.bat` | `.\run.bat uvm_base` | `sim/run/` |
| `run_simple.bat` | `.\run.bat simple_tb` | `sim/run/` |

### Troubleshooting

#### Common Issues and Solutions

**Error: Configuration file not found**

```bash
# Solution: Ensure you're in the sim/run directory
cd sim/run
.\run.bat
```

**Error: Test configuration not found**

```bash
# Solution: Check available tests
.\run.bat
# Use exact test name from the list
```

**Simulation compilation errors**

- Check SystemVerilog syntax in source files
- Verify file paths in filelists
- Ensure DSIM license is valid

### Advanced Usage

#### For Detailed Debugging

Use UVM_HIGH verbosity tests or modify configuration:

```bash
.\run.bat axi4_advanced  # Uses UVM_HIGH verbosity
```

#### Waveform Analysis

Generated `.vcd` files can be viewed with:

- GTKWave (Free)
- ModelSim/QuestaSim
- Vivado Simulator

For detailed usage instructions, see the main execution script documentation.

## Conclusion

This project serves as a comprehensive example of using UVM for verifying designs that utilize the AXI4 interface. It provides a structured approach to understanding both UVM and the AXI4 protocol, while also documenting the verification process through detailed development logs.

### Key Achievements

- ✅ **Complete AXI4 Implementation**: Fully functional register memory module with comprehensive verification
- ✅ **Unified Test Management**: Configuration-driven system enabling easy test addition and maintenance  
- ✅ **Zero-Error Verification**: All tests pass with comprehensive coverage (14 bugs discovered and fixed)
- ✅ **Scalable Architecture**: Template-based system for future test expansion
- ✅ **Professional Documentation**: 300+ line test specifications and development insights

### Learning Outcomes

This project demonstrates:
- **UVM Methodology**: Practical application of UVM verification techniques
- **AXI4 Protocol**: Complete implementation and verification of AXI4 interface
- **SystemVerilog Best Practices**: Following industry-standard coding guidelines
- **Test Automation**: Professional test execution and reporting systems
- **Bug Discovery**: Systematic identification and resolution of RTL issues

### Next Steps

For further development:
1. **Advanced Test Cases**: Implement more sophisticated verification scenarios
2. **Coverage Analysis**: Add functional and code coverage metrics
3. **Performance Testing**: Implement timing and throughput verification
4. **Continuous Integration**: Set up automated regression testing

This project provides a solid foundation for advanced verification projects and serves as a practical reference for UVM and AXI4 implementation.