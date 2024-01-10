module uart_tx #(
    parameter BAUD_RATE  = 9600,
    parameter DATA_WIDTH = 8
) (
    input         clk,
    input         rst,
    input         tx_start,
    input  [7:0]  tx_data,
    output reg    tx_serial
);

  	// Assumes 10 MHz clock, calculates how long to hold tx_serial bits
    localparam CLKS_PER_BIT = 10_000_000 / BAUD_RATE; 
	
  	// Four different UART states
    localparam S_IDLE     = 2'b00,
               S_TX_START = 2'b01,
               S_TX_DATA  = 2'b10,
               S_TX_STOP  = 2'b11;
	
  	// Declare 
    reg [1:0]	state = S_IDLE;
    reg [1:0]	next_state = S_IDLE;
  
  	// Counters
    reg [3:0]  	data_index = 0;
    reg [11:0] 	clock_counter = 0;

    // State transition logic
    always @(posedge clk) begin
      if (rst) begin
            state <= S_IDLE;
      end else
            state <= next_state;
    end

    // Sequential counter increment logic
    always @(posedge clk) begin
        case (state)
            S_IDLE:     clock_counter <= 0;
            S_TX_DATA:  clock_counter <= (clock_counter < CLKS_PER_BIT) ? clock_counter + 1 : 0;
            default:    clock_counter <= (next_state == state)          ? clock_counter + 1 : 0;
        endcase
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            S_IDLE:     next_state = (tx_start)                     ? S_TX_START : S_IDLE;
            S_TX_START: next_state = (clock_counter < CLKS_PER_BIT) ? S_TX_START : S_TX_DATA;
            S_TX_DATA:  next_state = (clock_counter < CLKS_PER_BIT) ? S_TX_DATA  : (data_index < DATA_WIDTH-1) ? S_TX_DATA : S_TX_STOP;
            S_TX_STOP:  next_state = (clock_counter < CLKS_PER_BIT) ? S_TX_STOP  : S_IDLE;
        endcase
    end

    // TX data indexing logic
    always @(posedge clk) begin
        case (state)
            S_TX_DATA:  data_index <= (clock_counter < CLKS_PER_BIT) ? data_index : data_index + 1;
            default:    data_index <= 0;
        endcase
    end

    // TX serial output logic
    always @(*) begin
        case (state)
            S_IDLE:     tx_serial = 1'b1;
            S_TX_START: tx_serial = 1'b0;
            S_TX_DATA:  tx_serial = tx_data[data_index];
            S_TX_STOP:  tx_serial = 1'b1;
        endcase
    end

endmodule
