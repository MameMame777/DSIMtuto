class axi4_write_seq extends axi4_base_seq;

  // Transaction data
  rand bit [31:0] addr; // Address for the write transaction
  rand bit [31:0] data; // Data to be written

  // Constructor
  function new(string name = "axi4_write_seq");
    super.new(name);
  endfunction

  // Randomize the transaction data
  function void body();
    // Randomly generate address and data
    assert (randomize() with { addr dist { [0:255] :/ 1 }; data dist { [0:255] :/ 1 }; }) else
      `uvm_fatal("RANDOMIZE_FAIL", "Randomization failed!");

    // Create a write transaction
    axi4_transaction wr_tx;
    wr_tx = axi4_transaction::type_id::create("wr_tx");

    // Set the transaction fields
    wr_tx.addr = addr;
    wr_tx.data = data;
    wr_tx.write = 1; // Indicate this is a write transaction

    // Start the transaction
    start_item(wr_tx);
    // Send the transaction
    finish_item(wr_tx);
  endfunction

endclass