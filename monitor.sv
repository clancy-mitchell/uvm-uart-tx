class Monitor;

  // Interface declaration
  virtual uart_tx_interface uart_tx_vif; 	
	
  // Mailbox declaration to send to scoreboard
  mailbox scoreboard_mon_mailbox;
  
  // Sequence captured event for synchronization with driver
  event monitor_done;
  event driver_done;
  
  // UART timing details
  int baud_rate = 9600; 
  int clk_freq = 10_000_000;
  int clks_per_bit = (clk_freq / baud_rate) * 2;

  task run();
	
    // Continously send DUT outputs to scoreboard
    forever begin
 
      // Itialize new serial sequence 
      logic [7:0] tx_serial_sequence;
      logic tx_start_bit;
      logic tx_stop_bit;
      
      // Intialize empty sequence
      TXSequence seq = new();

      // Blocking statement, wait for start bit
      @(posedge uart_tx_vif.tx_start);
      
      // Sample start bit, delaying until halfway through start bit
      #(clks_per_bit/2) seq.tx_start_bit = uart_tx_vif.tx_serial;

      // Sample serial data bits, waiting till halfway through each bit
      #(clks_per_bit) seq.tx_serial_seq[0] = uart_tx_vif.tx_serial;
      #(clks_per_bit) seq.tx_serial_seq[1] = uart_tx_vif.tx_serial;
      #(clks_per_bit) seq.tx_serial_seq[2] = uart_tx_vif.tx_serial;
      #(clks_per_bit) seq.tx_serial_seq[3] = uart_tx_vif.tx_serial;
      #(clks_per_bit) seq.tx_serial_seq[4] = uart_tx_vif.tx_serial;
      #(clks_per_bit) seq.tx_serial_seq[5] = uart_tx_vif.tx_serial;
      #(clks_per_bit) seq.tx_serial_seq[6] = uart_tx_vif.tx_serial;
      #(clks_per_bit) seq.tx_serial_seq[7] = uart_tx_vif.tx_serial;
      
      // Sample stop bit
      #(clks_per_bit) seq.tx_stop_bit = uart_tx_vif.tx_serial;
      
      // Wait for stop bit to finish 
      #(clks_per_bit);
      
      // Pass captured sequence to scoreboard
      scoreboard_mon_mailbox.put(seq);
      
      // Promt generator for another test case
      ->monitor_done;
      
    end
    
  endtask
  
endclass