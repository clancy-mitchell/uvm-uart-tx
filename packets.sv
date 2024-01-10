class UARTPacket;

  // Declare controlled inputs
  bit rst;
  bit tx_start;
  
  // Declare randomized inputs
  rand bit [7:0] tx_data;
  
  // Declare outputs
  bit tx_serial;

  // Clone packets for scoreboard use
  function void copy(UARTPacket packet);
    this.rst        = packet.rst;
    this.tx_start   = packet.tx_start;
    this.tx_data    = packet.tx_data;
    this.tx_serial  = packet.tx_serial;
  endfunction
  
  // Packet data pretty print
  function void print(string label="");
    $display ("%s rst=0x%0h tx_start=0x%0h tx_data=0x%0h tx_serial=0x%0h", label, rst, tx_start, tx_data, tx_serial);
  endfunction
  
endclass

// Used in monitor for capturing serial tx sequences 
class TXSequence; 
  
  bit tx_start_bit; 
  bit tx_stop_bit; 
  bit [7:0] tx_serial_seq;
  
endclass
