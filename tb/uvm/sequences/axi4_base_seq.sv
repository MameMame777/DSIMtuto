class axi4_base_seq extends uvm_sequence #(axi4_transaction);

  `uvm_object_utils(axi4_base_seq)

  // Constructor
  function new(string name = "axi4_base_seq");
    super.new(name);
  endfunction

  // Task to execute the sequence
  virtual task body();
    axi4_transaction txn;

    // Example of generating a transaction
    txn = axi4_transaction::type_id::create("txn");

    // Set transaction properties (address, data, etc.)
    txn.addr = 32'h0000_0000; // Example address
    txn.data = 32'hDEADBEEF;  // Example data
    txn.write = 1;             // Indicate a write transaction

    // Start the transaction
    start_item(txn);
    // Send the transaction
    finish_item(txn);
  endtask

endclass