class axi4_env extends uvm_env;

  `uvm_component_utils(axi4_env)

  // AXI4 agent instance
  axi4_agent axi4_agent_inst;

  // AXI4 scoreboard instance
  axi4_scoreboard axi4_scoreboard_inst;

  // Constructor
  function new(string name = "axi4_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Instantiate the AXI4 agent
    axi4_agent_inst = axi4_agent::type_id::create("axi4_agent_inst", this);
    
    // Instantiate the AXI4 scoreboard
    axi4_scoreboard_inst = axi4_scoreboard::type_id::create("axi4_scoreboard_inst", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Connect the agent to the scoreboard
    axi4_agent_inst.mon.ap.connect(axi4_scoreboard_inst.ap);
  endfunction

endclass