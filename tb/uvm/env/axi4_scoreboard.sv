class axi4_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(axi4_scoreboard)

  // Transaction storage
  axi4_transaction req_trans;
  axi4_transaction rsp_trans;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Method to compare request and response transactions
  function void compare_transactions(axi4_transaction req, axi4_transaction rsp);
    if (req.addr != rsp.addr) begin
      `uvm_fatal("ADDR_MISMATCH", "Address mismatch between request and response")
    end
    if (req.data != rsp.data) begin
      `uvm_fatal("DATA_MISMATCH", "Data mismatch between request and response")
    end
    // Additional checks can be added here
  endfunction

  // Callback for receiving request transactions
  virtual function void write(axi4_transaction req);
    req_trans = req;
    // Wait for the corresponding response
    wait(rsp_trans != null);
    compare_transactions(req_trans, rsp_trans);
    rsp_trans = null; // Reset for next transaction
  endfunction

  // Callback for receiving response transactions
  virtual function void write_rsp(axi4_transaction rsp);
    rsp_trans = rsp;
  endfunction

endclass