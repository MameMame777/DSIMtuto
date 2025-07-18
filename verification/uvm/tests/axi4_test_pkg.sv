// This file packages the AXI4 test components for easier inclusion in the testbench.

package axi4_test_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

// Import other necessary packages
import axi4_seq_pkg::*;
import axi4_env_pkg::*;

class axi4_test_pkg extends uvm_object;

  // Constructor
  function new(string name = "axi4_test_pkg");
    super.new(name);
  endfunction

  // Function to register the test components
  function void register();
    uvm_component_utils(axi4_test_pkg);
  endfunction

endclass

// Register the package
`uvm_component_utils(axi4_test_pkg)