// AXI4 Base Test Class
// File: axi4_base_test.sv
// Author: SystemVerilog Testbench
// Date: July 15, 2025

`include "uvm_macros.svh"
import uvm_pkg::*;

class Axi4_Base_Test extends uvm_test;
    `uvm_component_utils(Axi4_Base_Test)

    // Virtual interface handle
    virtual axi4_if vif;

    function new(string name = "Axi4_Base_Test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Get virtual interface from config database
        if (!uvm_config_db#(virtual axi4_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Virtual interface not found in config database")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info(get_type_name(), "Starting AXI4 base test", UVM_MEDIUM)
        
        // Wait for reset deassertion
        wait(!vif.reset);
        repeat(10) @(posedge vif.clk);
        
        `uvm_info(get_type_name(), "Test completed successfully", UVM_MEDIUM)
        
        phase.drop_objection(this);
    endtask

endclass
