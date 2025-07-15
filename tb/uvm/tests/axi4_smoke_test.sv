// This file implements a simple smoke test for the AXI4 design.

class axi4_smoke_test extends axi4_base_test;

  // Test variables
  axi4_read_seq read_seq;
  axi4_write_seq write_seq;

  // Constructor
  function new(string name = "axi4_smoke_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    read_seq = axi4_read_seq::type_id::create("read_seq", this);
    write_seq = axi4_write_seq::type_id::create("write_seq", this);
  endfunction

  // Run phase
  virtual task run_phase(uvm_phase phase);
    // Start write sequence
    `uvm_info(get_type_name(), "Starting write sequence", UVM_MEDIUM)
    start(write_seq);

    // Start read sequence
    `uvm_info(get_type_name(), "Starting read sequence", UVM_MEDIUM)
    start(read_seq);
  endtask

  // Start a sequence
  virtual task start(axi4_base_seq seq);
    seq.start(m_sequencer);
  endtask

endclass : axi4_smoke_test