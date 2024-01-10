// UART TX DUT interface
interface uart_tx_interface();
  logic       clk; 
  logic       rst; 
  logic       tx_start; 
  logic [7:0] tx_data;
  logic       tx_serial;

  initial 		clk <= 0;
  always  		#1 clk <= ~clk;
endinterface