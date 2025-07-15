// This file packages the testbench components for easier inclusion in the simulation.

package tb_pkg;

import uvm_pkg::*; // Import UVM package

// Declare the package for the testbench components
class tb_pkg extends uvm_object;
  // Constructor
  function new(string name = "tb_pkg");
    super.new(name);
  endfunction

  // Function to register all components
  function void register();
    // Register UVM components here
    // e.g., `uvm_component_utils(your_component_class)`
  endfunction

endclass

// Register the package
tb_pkg tb_pkg_inst = new();