// AXI4 Register Memory Basic Test
// File: axi4_reg_mem_basic_test.sv
// Author: SystemVerilog Verification Team
// Date: July 15, 2025

`include "uvm_macros.svh"
import uvm_pkg::*;

class Axi4_Reg_Mem_Basic_Test extends uvm_test;
    `uvm_component_utils(Axi4_Reg_Mem_Basic_Test)

    // Virtual interface handle
    virtual axi4_if vif;

    function new(string name = "Axi4_Reg_Mem_Basic_Test", uvm_component parent = null);
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
        
        `uvm_info(get_type_name(), "Starting AXI4 Register Memory Basic Test", UVM_MEDIUM)
        
        // Wait for reset deassertion
        wait(!vif.reset);
        repeat(5) @(posedge vif.clk);
        
        // Test 1: Reset verification - check after reset deassertion
        test_reset_behavior();
        
        // Test 2: Basic write operation
        test_basic_write();
        
        // Test 3: Basic read operation  
        test_basic_read();
        
        // Test 4: Write-Read verification
        test_write_read_verify();
        
        // Test 5: Multiple address testing
        test_multiple_addresses();
        
        // Test 6: Data pattern testing
        test_data_patterns();
        
        `uvm_info(get_type_name(), "All basic tests completed successfully", UVM_MEDIUM)
        
        phase.drop_objection(this);
    endtask

    // Test 1: Reset behavior verification
    task test_reset_behavior();
        `uvm_info(get_type_name(), "Test 1: Reset behavior verification", UVM_MEDIUM)
        
        // At this point reset has been deasserted and we've waited 5 cycles
        // Ready signals should now be asserted (after reset deassertion)
        if (vif.awready !== 1'b1) `uvm_error(get_type_name(), "awready not asserted after reset")
        if (vif.wready !== 1'b1) `uvm_error(get_type_name(), "wready not asserted after reset")
        if (vif.arready !== 1'b1) `uvm_error(get_type_name(), "arready not asserted after reset")
        
        // Valid signals should remain low until explicitly driven
        if (vif.bvalid !== 1'b0) `uvm_error(get_type_name(), "bvalid not reset properly")
        if (vif.rvalid !== 1'b0) `uvm_error(get_type_name(), "rvalid not reset properly")
        
        `uvm_info(get_type_name(), "Reset behavior verification PASSED", UVM_MEDIUM)
    endtask

    // Test 2: Basic write operation
    task test_basic_write();
        `uvm_info(get_type_name(), "Test 2: Basic write operation", UVM_MEDIUM)
        
        // Initialize all signals
        initialize_axi_signals();
        
        // Perform write operation
        axi_write(32'h00000004, 32'hDEADBEEF, 4'hF);
        
        `uvm_info(get_type_name(), "Basic write operation PASSED", UVM_MEDIUM)
    endtask

    // Test 3: Basic read operation
    task test_basic_read();
        logic [31:0] read_data;
        `uvm_info(get_type_name(), "Test 3: Basic read operation", UVM_MEDIUM)
        
        // Initialize all signals
        initialize_axi_signals();
        
        // Perform read operation
        axi_read(32'h00000004, read_data);
        
        `uvm_info(get_type_name(), $sformatf("Read data: 0x%08h", read_data), UVM_MEDIUM)
        `uvm_info(get_type_name(), "Basic read operation PASSED", UVM_MEDIUM)
    endtask

    // Test 4: Write-Read verification
    task test_write_read_verify();
        logic [31:0] write_data, read_data;
        logic [31:0] test_addr;
        
        `uvm_info(get_type_name(), "Test 4: Write-Read verification", UVM_MEDIUM)
        
        test_addr = 32'h00000008;
        write_data = 32'h12345678;
        
        // Write data
        axi_write(test_addr, write_data, 4'hF);
        
        // Read back data
        axi_read(test_addr, read_data);
        
        // Verify data integrity
        if (read_data === write_data) begin
            `uvm_info(get_type_name(), 
                $sformatf("Write-Read verification PASSED: addr=0x%08h, data=0x%08h", 
                test_addr, read_data), UVM_MEDIUM)
        end else begin
            `uvm_error(get_type_name(), 
                $sformatf("Write-Read verification FAILED: addr=0x%08h, expected=0x%08h, actual=0x%08h", 
                test_addr, write_data, read_data))
        end
    endtask

    // Test 5: Multiple address testing
    task test_multiple_addresses();
        logic [31:0] addresses[$] = {32'h00000000, 32'h00000004, 32'h00000008, 32'h000000FC, 32'h000003FC};
        logic [31:0] write_data, read_data;
        
        `uvm_info(get_type_name(), "Test 5: Multiple address testing", UVM_MEDIUM)
        
        foreach (addresses[i]) begin
            write_data = 32'hA5A5A5A5 + i;
            
            // Write to address
            axi_write(addresses[i], write_data, 4'hF);
            
            // Read back and verify
            axi_read(addresses[i], read_data);
            
            if (read_data === write_data) begin
                `uvm_info(get_type_name(), 
                    $sformatf("Address test PASSED: addr=0x%08h, data=0x%08h", 
                    addresses[i], read_data), UVM_MEDIUM)
            end else begin
                `uvm_error(get_type_name(), 
                    $sformatf("Address test FAILED: addr=0x%08h, expected=0x%08h, actual=0x%08h", 
                    addresses[i], write_data, read_data))
            end
        end
        
        `uvm_info(get_type_name(), "Multiple address testing PASSED", UVM_MEDIUM)
    endtask

    // Test 6: Data pattern testing
    task test_data_patterns();
        logic [31:0] patterns[$] = {32'h00000000, 32'hFFFFFFFF, 32'hAAAAAAAA, 32'h55555555, 32'h12345678};
        logic [31:0] test_addr, read_data;
        
        `uvm_info(get_type_name(), "Test 6: Data pattern testing", UVM_MEDIUM)
        
        test_addr = 32'h00000010;
        
        foreach (patterns[i]) begin
            // Write pattern
            axi_write(test_addr, patterns[i], 4'hF);
            
            // Read back and verify
            axi_read(test_addr, read_data);
            
            if (read_data === patterns[i]) begin
                `uvm_info(get_type_name(), 
                    $sformatf("Pattern test PASSED: pattern=0x%08h", patterns[i]), UVM_MEDIUM)
            end else begin
                `uvm_error(get_type_name(), 
                    $sformatf("Pattern test FAILED: expected=0x%08h, actual=0x%08h", 
                    patterns[i], read_data))
            end
        end
        
        `uvm_info(get_type_name(), "Data pattern testing PASSED", UVM_MEDIUM)
    endtask

    // AXI4 Write Task
    task axi_write(input [31:0] addr, input [31:0] data, input [3:0] strb);
        fork
            // Write Address Channel
            begin
                vif.awaddr = addr;
                vif.awvalid = 1'b1;
                vif.awlen = 8'h00;     // Single transfer
                vif.awsize = 3'b010;   // 32-bit
                vif.awburst = 2'b01;   // INCR
                vif.awid = 4'h0;
                
                @(posedge vif.clk);
                wait(vif.awready);
                @(posedge vif.clk);
                vif.awvalid = 1'b0;
            end
            
            // Write Data Channel
            begin
                vif.wdata = data;
                vif.wstrb = strb;
                vif.wvalid = 1'b1;
                vif.wlast = 1'b1;
                
                @(posedge vif.clk);
                wait(vif.wready);
                @(posedge vif.clk);
                vif.wvalid = 1'b0;
            end
            
            // Write Response Channel
            begin
                vif.bready = 1'b1;
                wait(vif.bvalid);
                @(posedge vif.clk);
                vif.bready = 1'b0;
                
                // Check response
                if (vif.bresp !== 2'b00) begin
                    `uvm_error(get_type_name(), $sformatf("Write response error: bresp=0x%0h", vif.bresp))
                end
            end
        join
        
        `uvm_info(get_type_name(), $sformatf("Write completed: addr=0x%08h, data=0x%08h", addr, data), UVM_HIGH)
    endtask

    // AXI4 Read Task
    task axi_read(input [31:0] addr, output [31:0] data);
        fork
            // Read Address Channel
            begin
                vif.araddr = addr;
                vif.arvalid = 1'b1;
                vif.arlen = 8'h00;     // Single transfer
                vif.arsize = 3'b010;   // 32-bit
                vif.arburst = 2'b01;   // INCR
                vif.arid = 4'h0;
                
                @(posedge vif.clk);
                wait(vif.arready);
                @(posedge vif.clk);
                vif.arvalid = 1'b0;
            end
            
            // Read Data Channel
            begin
                vif.rready = 1'b1;
                wait(vif.rvalid);
                data = vif.rdata;
                @(posedge vif.clk);
                vif.rready = 1'b0;
                
                // Check response
                if (vif.rresp !== 2'b00) begin
                    `uvm_error(get_type_name(), $sformatf("Read response error: rresp=0x%0h", vif.rresp))
                end
            end
        join
        
        `uvm_info(get_type_name(), $sformatf("Read completed: addr=0x%08h, data=0x%08h", addr, data), UVM_HIGH)
    endtask

    // Initialize AXI signals to default values
    task initialize_axi_signals();
        vif.awvalid = 1'b0;
        vif.awaddr = 32'h0;
        vif.awlen = 8'h0;
        vif.awsize = 3'b0;
        vif.awburst = 2'b0;
        vif.awid = 4'h0;
        
        vif.wvalid = 1'b0;
        vif.wdata = 32'h0;
        vif.wstrb = 4'h0;
        vif.wlast = 1'b0;
        
        vif.bready = 1'b0;
        
        vif.arvalid = 1'b0;
        vif.araddr = 32'h0;
        vif.arlen = 8'h0;
        vif.arsize = 3'b0;
        vif.arburst = 2'b0;
        vif.arid = 4'h0;
        
        vif.rready = 1'b0;
        
        @(posedge vif.clk);
    endtask

endclass
