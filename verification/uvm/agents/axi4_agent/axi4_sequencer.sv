class axi4_sequencer extends uvm_sequencer #(axi4_transaction);
  
  `uvm_component_utils(axi4_sequencer)

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Function to start a sequence
  function void start_sequence(axi4_base_seq seq);
    // Start the sequence
    seq.start(this);
  endfunction

  // Function to generate a read transaction
  function void generate_read_transaction();
    axi4_transaction trans;
    trans = axi4_transaction::type_id::create("trans");
    trans.set_read(); // Set the transaction as a read
    start_sequence(trans);
  endfunction

  // Function to generate a write transaction
  function void generate_write_transaction();
    axi4_transaction trans;
    trans = axi4_transaction::type_id::create("trans");
    trans.set_write(); // Set the transaction as a write
    start_sequence(trans);
  endfunction

endclass