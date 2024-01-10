`include "interface.sv"
`include "test.sv"

module testbench;
  
  // Interface Declaration
  uart_tx_interface uart_tx_if();
  
  // Instantiate DUT and map interface
  uart_tx DUT(
    .clk(uart_tx_if.clk),
    .rst(uart_tx_if.rst),
    .tx_start(uart_tx_if.tx_start),
    .tx_data(uart_tx_if.tx_data),
    .tx_serial(uart_tx_if.tx_serial)
  );

  initial begin
    
    // Instantiate test
    MainTest test;
    test = new();
    
    // Pass interfaces to the testing environment
    test.env.uart_tx_vif  = uart_tx_if;
    
    // Start tests
    test.run();
    $finish;
    
  end
  
endmodule