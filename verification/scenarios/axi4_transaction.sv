class axi4_transaction;
  // AXI4 transaction signals
  bit [31:0] addr;      // Address
  bit [31:0] data;      // Data
  bit [3:0]  strb;      // Byte strobes
  bit        valid;      // Valid signal
  bit        ready;      // Ready signal
  bit        read;       // Read/Write indicator

  // Constructor
  function new();
    addr = 32'h0;
    data = 32'h0;
    strb = 4'hF; // Default to all bytes valid
    valid = 1'b0;
    ready = 1'b0;
    read = 1'b0; // Default to write
  endfunction

  // Method to display transaction details
  function void display();
    $display("AXI4 Transaction: addr=%h, data=%h, strb=%b, valid=%b, ready=%b, read=%b",
             addr, data, strb, valid, ready, read);
  endfunction
endclass