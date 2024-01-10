class Environment;
  
  // Primary environment components
  Generator		gen; 		
  Driver		drv; 			
  Monitor 		mon; 			
  Scoreboard 	scb;
  
  // Declare mailboxes
  mailbox		scoreboard_drv_mailbox;
  mailbox		scoreboard_mon_mailbox;
  mailbox		driver_mailbox;
  
  // Interface declaration
  virtual uart_tx_interface uart_tx_vif; 	
  
  // Event signal for monitor done capturing output sequence
  event monitor_done;

  // Environment Constructor
  function new();
    
    // Intialize components
    drv = new();
    mon = new();
    scb = new();
    gen = new();
    
    // Initialize mailboxes
    driver_mailbox = new();
    scoreboard_drv_mailbox = new();
    scoreboard_mon_mailbox = new();
    
  endfunction

  // Run the environment 
  task run();

    // Pass uart tx interface to driver and monitor
    drv.uart_tx_vif = uart_tx_vif;
    mon.uart_tx_vif = uart_tx_vif;

    // Mail route from generator to driver
    drv.driver_mailbox = driver_mailbox;
    gen.driver_mailbox = driver_mailbox;
    
    // Mail route from driver to scoreboard
    drv.scoreboard_drv_mailbox = scoreboard_drv_mailbox;
    scb.scoreboard_drv_mailbox = scoreboard_drv_mailbox;
	
    // Mail route from monitor to scoreboard
    mon.scoreboard_mon_mailbox = scoreboard_mon_mailbox;
    scb.scoreboard_mon_mailbox = scoreboard_mon_mailbox; 
    
    // Link sequence captured event to driver and monitor
    mon.monitor_done = monitor_done;
    gen.monitor_done = monitor_done;

	// Start each environment component
    fork
      scb.run();
      drv.run();
      mon.run();
      gen.run();
    join_any
    
    scb.summarize_results();
    
  endtask
endclass