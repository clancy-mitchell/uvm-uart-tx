class Driver;

  // Interface declaration
  virtual uart_tx_interface uart_tx_vif; 	

  // Mailbox declaration to recieve from generator
  mailbox driver_mailbox;
  
  // Mailbox declaration to send to scoreboard
  mailbox scoreboard_drv_mailbox;
  
  // Event declaration for monitor
  event monitor_done;

  // Reset procedure for uart_tx module
  task reset(); 
    @(negedge uart_tx_vif.clk);
    uart_tx_vif.rst = 1'b1;
    @(negedge uart_tx_vif.clk);
    uart_tx_vif.rst = 1'b0;
  endtask

  task run();
    
    reset();

    // Write packets to DUT as they come 
    forever begin
      
      // Blocking statement, wait for a packet from the generator
      UARTPacket packet;    
      driver_mailbox.get(packet);

      // Work on the tb clocks schedule
      @(negedge uart_tx_vif.clk);

      // Unpack packet and map to DUT interface
      uart_tx_vif.rst 	    <= packet.rst;
      uart_tx_vif.tx_start 	<= packet.tx_start;
      uart_tx_vif.tx_data  	<= packet.tx_data;

      // Wait one cycle then set tx_start to low
      @(negedge uart_tx_vif.clk);
      uart_tx_vif.tx_start <= 1'b0;
      
      packet.print("[\tDriver\t\t]");
      
      // Send driven to scoreboard for later comparison with uart serial tx output
      scoreboard_drv_mailbox.put(packet);
       
    end
    
  endtask

endclass