// This file packages the AXI4 sequence components for easier inclusion in the testbench.

package axi4_seq_pkg;

  import uvm_pkg::*; // Import UVM package

  // Base sequence class for AXI4 transactions
  class axi4_base_seq extends uvm_sequence #(axi4_transaction);
    `uvm_object_utils(axi4_base_seq)

    // Constructor
    function new(string name = "axi4_base_seq");
      super.new(name);
    endfunction

    // Define the body of the sequence
    virtual task body();
      // Sequence implementation goes here
    endtask

  endclass

  // Include other sequences
  `include "axi4_read_seq.sv"
  `include "axi4_write_seq.sv"

endpackage : axi4_seq_pkg