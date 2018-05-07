module system_INTERFACE
	(
		SW, KEY, LCD_DATA, LCD_EN, LCD_ON, LCD_RS, LCD_RW, LEDG, LEDR, CLOCK_50, HEX1, HEX0, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
	);
	
	input CLOCK_50;
	input [17:0] SW;
	input [3:0] KEY;
	output [7:0] LEDG;
	output [0:0] LEDR;
	output [7:0] LCD_DATA;
	output LCD_EN, LCD_RS, LCD_RW, LCD_ON;
	output [7:0] HEX0;
	output [7:0] HEX1;
	output [7:0] HEX2;
	output [7:0] HEX3;
	output [7:0] HEX4;
	output [7:0] HEX5;
	output [7:0] HEX6;
	output [7:0] HEX7;
	
	
	system interface
	(
		.LCD_CLK(CLOCK_50),
		.SYS_clk_in(KEY[0]),
		.SYS_rst(KEY[3]),
		.SYS_load(SW[9]),
		.SYS_pc_val(SW[17:10]), /// use SYS_load to load value into PC[8..0]
		.SYS_leds(LEDG[7:0]),
		.SYS_output_sel(SW[7:0]),
		.EH_led(LEDR[0]),
		.hex0(HEX0),
		.hex1(HEX1),
		.hex2(HEX2),
		.hex3(HEX3),
		.hex4(HEX4),
		.hex5(HEX5),
		.hex6(HEX6),
		.hex7(HEX7),
		
		// LCD module
		.LCD_DATA(LCD_DATA),
		.LCD_ON(LCD_ON),
		.LCD_RS(LCD_RS), 
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN)
	);
	
endmodule 