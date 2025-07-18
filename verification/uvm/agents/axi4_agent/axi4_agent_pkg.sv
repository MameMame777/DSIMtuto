// This file packages the AXI4 agent components for easier inclusion in the testbench.

package axi4_agent_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class axi4_agent extends uvm_agent;
    `uvm_component_utils(axi4_agent)

    // Declare driver, monitor, and sequencer
    axi4_driver       driver;
    axi4_monitor      monitor;
    axi4_sequencer    sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = axi4_driver::type_id::create("driver", this);
        monitor = axi4_monitor::type_id::create("monitor", this);
        sequencer = axi4_sequencer::type_id::create("sequencer", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect sequencer to driver
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

// Package declaration for easier inclusion
endpackage : axi4_agent_pkg