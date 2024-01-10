class Scoreboard;

  // Mailbox declaration to recieve packets from monitor
  mailbox scoreboard_drv_mailbox;
  mailbox scoreboard_mon_mailbox;
  
  // Keep track of score
  int pass_tally = 0;
  int fail_tally = 0;

  task run();

    // Continously score monitors readings 
    forever begin

      UARTPacket uart_packet; 
      TXSequence tx_seq;
      
      // Blocking statement, wait for a uart driver packet and uart tx output sequence
      scoreboard_drv_mailbox.get(uart_packet);
      scoreboard_mon_mailbox.get(tx_seq);
      
      // Compare intended tx data to received data
      if (uart_packet.tx_data == tx_seq.tx_serial_seq) begin
        pass_tally++;
        $display("[\tScoreboard\t] PASS: byte sent: 0x%0h, byte received = 0x%0h\n", uart_packet.tx_data, tx_seq.tx_serial_seq);
      end else begin
        fail_tally++;
        $display("[\tScoreboard\t] FAIL: byte sent: 0x%0h, byte received = 0x%0h\n", uart_packet.tx_data, tx_seq.tx_serial_seq);
      end

    end

  endtask
  
  task summarize_results();
    $display("\nTESTBENCH RESULTS:");
    $display("\tPASS TALLY: %0d/%0d", pass_tally, pass_tally+fail_tally);
    $display("\tFAIL TALLY: %0d/%0d\n\n\n", fail_tally, pass_tally+fail_tally);
  endtask
             

endclass