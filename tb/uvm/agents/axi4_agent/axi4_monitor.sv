class axi4_monitor extends uvm_monitor;

  // Declare the AXI4 transaction type
  `uvm_component_utils(axi4_monitor)

  // AXI4 interface signals
  axi4_if axi4_if; // Assuming axi4_if is defined in rtl/axi4_if.sv

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Start the monitor
  virtual function void start_of_simulation();
    // Initialize the monitor
    uvm_report_info("AXI4 Monitor", "Starting AXI4 Monitor", UVM_MEDIUM);
  endfunction

  // Main monitoring task
  virtual task run();
    forever begin
      // Wait for a valid transaction on the AXI4 interface
      @(posedge axi4_if.axi_valid);
      
      // Collect transaction data
      axi4_transaction trans;
      trans = axi4_transaction::type_id::create("trans");
      trans.addr = axi4_if.axi_addr;
      trans.data = axi4_if.axi_data;
      trans.read = axi4_if.axi_read;
      trans.write = axi4_if.axi_write;

      // Send the transaction to the analysis phase
      // Assuming there is an analysis port connected to a scoreboard
      // analysis_port.write(trans);
      uvm_report_info("AXI4 Monitor", $sformatf("Transaction captured: Addr=%0h, Data=%0h", trans.addr, trans.data), UVM_MEDIUM);
      
      // Add a delay or wait for the next transaction
      @(posedge axi4_if.axi_ready);
    end
  endtask

endclass