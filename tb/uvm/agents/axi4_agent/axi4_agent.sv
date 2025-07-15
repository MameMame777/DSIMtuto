class axi4_agent extends uvm_agent;

  `uvm_component_utils(axi4_agent)

  // Components of the AXI4 agent
  axi4_driver     driver;
  axi4_monitor     monitor;
  axi4_sequencer   sequencer;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = axi4_driver::type_id::create("driver", this);
    monitor = axi4_monitor::type_id::create("monitor", this);
    sequencer = axi4_sequencer::type_id::create("sequencer", this);
  endfunction

  // Connect phase
  virtual function void connect_phase(uvm_phase phase);
    // Connect the driver and sequencer
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass