class axi4_driver extends uvm_driver #(axi4_transaction);
  
  `uvm_component_utils(axi4_driver)

  // AXI4 interface signals
  axi4_if axi4_if;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Main run function
  virtual task run_phase(uvm_phase phase);
    axi4_transaction tx;

    // Main driving loop
    forever begin
      // Get a transaction from the sequencer
      seq_item_port.get_next_item(tx);

      // Drive the AXI4 signals based on the transaction
      drive_axi4_signals(tx);

      // Indicate that the transaction has been processed
      seq_item_port.item_done();
    end
  endtask

  // Task to drive AXI4 signals
  task drive_axi4_signals(axi4_transaction tx);
    // Implement the logic to drive the AXI4 interface signals
    // based on the transaction fields
    // Example:
    // axi4_if.awaddr <= tx.addr;
    // axi4_if.awvalid <= 1;
    // ... (other signal assignments)
    
    // Wait for a clock cycle
    @(posedge axi4_if.aclk);
    
    // Clear the valid signals after driving
    axi4_if.awvalid <= 0;
    // ... (clear other signals)
  endtask

endclass