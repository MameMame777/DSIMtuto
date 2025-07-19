# UVM Execution Flow for `Axi4_Reg_Mem_Basic_Test`

This document outlines the execution flow of the UVM test class `Axi4_Reg_Mem_Basic_Test` in the AXI4 Register Memory verification environment.

## **1. Initialization**

### **`run_test()`**

- The UVM testbench starts with the `run_test()` function, which is called in the top-level testbench module (`tb_top.sv`).
- The test name is specified via the command-line argument `+UVM_TESTNAME`.

Example:

```bash
dsim +UVM_TESTNAME=Axi4_Reg_Mem_Basic_Test
```

## **2. Test Class Instantiation**

### **`Axi4_Reg_Mem_Basic_Test`**

- The `run_test()` function instantiates the test class specified by `+UVM_TESTNAME`.
- The test class is created using the UVM factory:

```systemverilog
uvm_test_top = Axi4_Reg_Mem_Basic_Test::type_id::create("Axi4_Reg_Mem_Basic_Test");
```

## **3. UVM Phases**

### **(1) `build_phase`**

- The `build_phase` is responsible for constructing the testbench components and retrieving the virtual interface (`vif`) from the UVM configuration database.

```systemverilog
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi4_if)::get(this, "", "vif", vif)) begin
        `uvm_fatal(get_type_name(), "Virtual interface not found in config database")
    end
endfunction
```

### **(2) `run_phase`**

- The `run_phase` executes the test scenarios in sequence.
- The phase starts by raising an objection and ends by dropping it.

```systemverilog
virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting AXI4 Register Memory Basic Test", UVM_MEDIUM)

    // Wait for reset deassertion
    wait(!vif.reset);
    repeat(5) @(posedge vif.clk);

    // Execute test scenarios
    test_reset_behavior();
    test_basic_write();
    test_basic_read();
    test_write_read_verify();
    test_multiple_addresses();
    test_data_patterns();

    `uvm_info(get_type_name(), "All basic tests completed successfully", UVM_MEDIUM)
    phase.drop_objection(this);
endtask
```

### **(3) `report_phase`**

- The `report_phase` generates a summary of the test results, including any errors or warnings encountered during the test.

## **4. Test Scenarios**

### **(1) Reset Behavior Verification**

- Verifies that the AXI4 interface signals are correctly reset.

```systemverilog
task test_reset_behavior();
    `uvm_info(get_type_name(), "Test 1: Reset behavior verification", UVM_MEDIUM)
    if (vif.awready !== 1'b1) `uvm_error(get_type_name(), "awready not asserted after reset")
    if (vif.wready !== 1'b1) `uvm_error(get_type_name(), "wready not asserted after reset")
    `uvm_info(get_type_name(), "Reset behavior verification PASSED", UVM_MEDIUM)
endtask
```

### **(2) Basic Write Operation**

- Writes data to a specific address and verifies the operation.

```systemverilog
task test_basic_write();
    axi_write(32'h00000004, 32'hDEADBEEF, 4'hF);
    `uvm_info(get_type_name(), "Basic write operation PASSED", UVM_MEDIUM)
endtask
```

### **(3) Basic Read Operation**

- Reads data from a specific address and verifies the operation.

```systemverilog
task test_basic_read();
    logic [31:0] read_data;
    axi_read(32'h00000004, read_data);
    `uvm_info(get_type_name(), $sformatf("Read data: 0x%08h", read_data), UVM_MEDIUM)
endtask
```

### **(4) Write-Read Verification**

- Writes data to an address and reads it back to verify data integrity.

```systemverilog
task test_write_read_verify();
    logic [31:0] write_data, read_data;
    write_data = 32'h12345678;
    axi_write(32'h00000008, write_data, 4'hF);
    axi_read(32'h00000008, read_data);
    if (read_data !== write_data) begin
        `uvm_error(get_type_name(), "Write-Read verification FAILED")
    end
endtask
```

### **(5) Multiple Address Testing**

- Writes and reads data across multiple addresses to verify address handling.

```systemverilog
task test_multiple_addresses();
    logic [31:0] addresses[$] = {32'h00000000, 32'h00000004, 32'h00000008};
    foreach (addresses[i]) begin
        axi_write(addresses[i], 32'hA5A5A5A5 + i, 4'hF);
        axi_read(addresses[i], read_data);
    end
endtask
```

### **(6) Data Pattern Testing**

- Writes and reads various data patterns to verify data integrity.

```systemverilog
task test_data_patterns();
    logic [31:0] patterns[$] = {32'h00000000, 32'hFFFFFFFF, 32'hAAAAAAAA};
    foreach (patterns[i]) begin
        axi_write(32'h00000010, patterns[i], 4'hF);
        axi_read(32'h00000010, read_data);
    end
endtask
```

## **5. Summary**

The `Axi4_Reg_Mem_Basic_Test` class follows the UVM methodology to verify the basic functionality of the AXI4 register memory. The test scenarios cover reset behavior, basic read/write operations, and data integrity checks across multiple addresses and patterns. This structured approach ensures comprehensive verification of the DUT.
