`include "package.sv"

class MainTest;

  // Declarations
  Environment env;

  // mainTest Constructor
  function new();
    env = new();
  endfunction

  // Run the test environment
  task run();
    env.run();
  endtask
  
endclass