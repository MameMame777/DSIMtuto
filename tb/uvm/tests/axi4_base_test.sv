// This file defines the base test class for AXI4 verification.

class axi4_base_test extends uvm_test;

  `uvm_component_utils(axi4_base_test)

  // Declare the environment and other components
  axi4_env env;

  // Constructor
  function new(string name = "axi4_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = axi4_env::type_id::create("env", this);
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    // Start the test execution
    uvm_report_info("axi4_base_test", "Starting the AXI4 base test...");
    // Add test logic here
  endtask

endclass