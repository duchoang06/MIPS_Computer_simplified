/*
PIN Assignments:
SYS_clk: CLK50;
SYS_rst: KEY[0];
SYS_load: KEY[1];
SYS_pc_val: SW[7:0]
SYS_output_sel: SW[14:8] or via IR.
SYS_leds: LEDG, LEDR.
SYS_hex0: HEX[0]
....
SYS_hex7: HEX[7]
*/

module system
	(
		input SYS_clk,
		input SYS_rst,
		input SYS_load,
		input [7:0] SYS_pc_val, /// use SYS_load to load value into PC[8..0]
		input [7:0] SYS_output_sel,
		output [26:0] SYS_leds,
		// additional
		output [6:0] SYS_hex0;
		output [6:0] SYS_hex1;
		output [6:0] SYS_hex2;
		output [6:0] SYS_hex3;
		
		output [6:0] SYS_hex4;
		output [6:0] SYS_hex5;
		output [6:0] SYS_hex6;
		output [6:0] SYS_hex7;
	);

always @(posedge SYS_clk, negedge SYS_rst)
	begin


	end



endmodule

