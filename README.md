# UVM - UART TX Module

Verification of a UART TX module using [UVM](https://en.wikipedia.org/wiki/Universal_Verification_Methodology) and [Cadence Xcelium](https://www.cadence.com/en_US/home/tools/system-design-and-verification/simulation-and-testbench-verification/xcelium-simulator.html).

## Waveform
![](https://github.com/clancy-mitchell/uvm-uart-tx/blob/main/waveform.png)

## Example Output
```
xcelium> run
[	Generator	] test 1/5 
[	Driver		] rst=0x0 tx_start=0x1 tx_data=0xec tx_serial=0x0
[	Scoreboard	] PASS: byte sent: 0xec, byte received = 0xec

[	Generator	] test 2/5 
[	Driver		] rst=0x0 tx_start=0x1 tx_data=0xb8 tx_serial=0x0
[	Scoreboard	] PASS: byte sent: 0xb8, byte received = 0xb8

[	Generator	] test 3/5 
[	Driver		] rst=0x0 tx_start=0x1 tx_data=0x72 tx_serial=0x0
[	Scoreboard	] PASS: byte sent: 0x72, byte received = 0x72

[	Generator	] test 4/5 
[	Driver		] rst=0x0 tx_start=0x1 tx_data=0x13 tx_serial=0x0
[	Scoreboard	] PASS: byte sent: 0x13, byte received = 0x13

[	Generator	] test 5/5 
[	Driver		] rst=0x0 tx_start=0x1 tx_data=0x68 tx_serial=0x0
[	Scoreboard	] PASS: byte sent: 0x68, byte received = 0x68


TESTBENCH RESULTS:
	PASS TALLY: 5/5
	FAIL TALLY: 0/5
```

