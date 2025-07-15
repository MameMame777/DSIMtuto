# DSIM Test Execution System

This directory contains a unified test execution system for DSIM simulation using configuration-driven approach.

## Overview

The test execution system consists of:
- `run.bat`: Main execution script
- `test_config.cfg`: Test configuration file
- `filelists/`: Directory containing source file lists for each test

## Usage

### Basic Usage

```bash
# Show available test configurations
run.bat

# Run a specific test
run.bat [TEST_NAME]
```

### Available Test Configurations

Current test configurations defined in `test_config.cfg`:

| Test Name | Description | Type |
|-----------|-------------|------|
| `axi4_reg_mem_basic` | AXI4 Register Memory Basic Test | UVM |
| `axi4_system` | AXI4 System Integration Test | Non-UVM |
| `uvm_base` | UVM Base Framework Test | UVM |
| `simple_tb` | Simple Testbench | Non-UVM |

### Examples

```bash
# Run AXI4 register memory basic test
run.bat axi4_reg_mem_basic

# Run AXI4 system integration test  
run.bat axi4_system

# Run UVM base framework test
run.bat uvm_base

# Show all available tests
run.bat
```

## Configuration File Format

The `test_config.cfg` file uses pipe-delimited format:

```
TEST_NAME|DESCRIPTION|FILELIST|UVM_TESTNAME|WAVES_FILE|UVM_VERBOSITY
```

### Fields Description

- **TEST_NAME**: Unique identifier for the test
- **DESCRIPTION**: Human-readable description
- **FILELIST**: Path to filelist file containing source files
- **UVM_TESTNAME**: UVM test class name (empty for non-UVM tests)
- **WAVES_FILE**: Output waveform file name
- **UVM_VERBOSITY**: UVM verbosity level (UVM_LOW, UVM_MEDIUM, UVM_HIGH)

### Example Configuration Entry

```
axi4_reg_mem_basic|AXI4 Register Memory Basic Test|filelists/axi4_reg_mem.f|Axi4_Reg_Mem_Basic_Test|axi4_reg_mem_waves.vcd|UVM_MEDIUM
```

## Filelist Format

Filelist files contain source files needed for compilation, one file per line:

```systemverilog
# AXI4 Register Memory Test Filelist
..\rtl\interfaces\axi4_if.sv
..\rtl\axi4_reg_mem.sv
..\tb\tests\axi4_reg_mem_basic_test.sv
..\tb\top\axi4_reg_mem_tb.sv
```

## Adding New Tests

To add a new test configuration:

1. **Create a filelist** in `filelists/` directory:
   ```bash
   # Example: filelists/my_new_test.f
   ..\rtl\my_module.sv
   ..\tb\my_test.sv
   ..\tb\top\my_tb_top.sv
   ```

2. **Add configuration entry** to `test_config.cfg`:
   ```
   my_new_test|My New Test Description|filelists/my_new_test.f|My_Test_Class|my_test_waves.vcd|UVM_MEDIUM
   ```

3. **Run the new test**:
   ```bash
   run.bat my_new_test
   ```

## Features

### Automatic Environment Setup
- DSIM license configuration
- Environment activation
- UVM library integration

### Flexible Test Types
- UVM-based tests with automatic UVM flags
- Non-UVM tests for simple verification
- Configurable verbosity levels

### Error Handling
- Configuration file validation
- Filelist existence checking
- Detailed error messages
- Exit code propagation

### Output Management
- Configurable waveform file names
- Test execution summaries
- Success/failure reporting

## Directory Structure

```
src/
├── run.bat                 # Main execution script
├── test_config.cfg         # Test configuration file
├── filelists/              # Source file lists
│   ├── axi4_reg_mem.f     # AXI4 register memory test files
│   ├── axi4_system.f      # AXI4 system test files
│   ├── uvm_base.f         # UVM base test files
│   └── simple.f           # Simple test files
└── README.md              # This file
```

## Legacy Scripts

The following legacy scripts are maintained for compatibility:
- `run_reg_mem_test.bat`
- `run_axi4_system.bat`
- `run_uvm.bat`
- `run_simple.bat`

These scripts are equivalent to calling:
- `run.bat axi4_reg_mem_basic`
- `run.bat axi4_system`
- `run.bat uvm_base`
- `run.bat simple_tb`

## Best Practices

1. **Test Naming**: Use descriptive, lowercase names with underscores
2. **Filelist Organization**: Group related files logically
3. **Documentation**: Comment configuration entries clearly
4. **Waveform Files**: Use descriptive names for easy identification
5. **Version Control**: Track changes to configuration files
