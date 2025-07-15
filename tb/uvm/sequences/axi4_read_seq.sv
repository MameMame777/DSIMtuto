class axi4_read_seq extends axi4_base_seq;

  // Transaction variable to hold the read request
  axi4_transaction read_req;

  // Constructor
  function new(string name = "axi4_read_seq");
    super.new(name);
  endfunction

  // Task to generate a read transaction
  task body();
    // Generate a read request
    read_req = axi4_transaction::type_id::create("read_req");
    
    // Set the address and other parameters for the read request
    read_req.addr = 32'h0000_0000; // Example address
    read_req.size = 3'b010;        // Example size (4 bytes)
    read_req.read = 1'b1;          // Indicate this is a read transaction

    // Start the transaction
    start_item(read_req);
    // Send the transaction
    finish_item(read_req);
  endtask

endclass