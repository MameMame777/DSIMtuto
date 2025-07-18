// This file defines the AXI4 environment package for the UVM testbench.
package axi4_env_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

// Environment class for AXI4 verification
class axi4_env extends uvm_env;
  `uvm_component_utils(axi4_env)

  // AXI4 agent instance
  axi4_agent axi4_agent_inst;
  // AXI4 scoreboard instance
  axi4_scoreboard axi4_scoreboard_inst;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axi4_agent_inst = axi4_agent::type_id::create("axi4_agent_inst", this);
    axi4_scoreboard_inst = axi4_scoreboard::type_id::create("axi4_scoreboard_inst", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    // Connect the agent and scoreboard here if needed
  endfunction

endclass

// Export the environment package
endpackage