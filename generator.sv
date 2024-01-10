class Generator;
  
  int num_test_cases = 5;
  
  // Event signal when driver asks for another packet
  event monitor_done;
  event packet_generated; 
  
  // mailbox declaration to send to driver
  mailbox driver_mailbox;

  task run();
    
    // Generate test cases
    for (int i = 0; i < num_test_cases; i++) begin
      
      // Initialize test packet and radomized transmit data
      UARTPacket packet = new();
      void'(packet.randomize());
      
      // Set control signals
      packet.tx_start = 1'b1;
      packet.rst = 1'b0;
      
      $display ("[\tGenerator\t] test %0d/%0d ", i+1, num_test_cases);
      
      // Send generated packet to the DUT driver
      driver_mailbox.put(packet);
      
      // Wait for monitor to finish reading uart tx output
      @(monitor_done);
    
    end
  endtask
  
endclass