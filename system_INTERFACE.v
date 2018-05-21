module system_INTERFACE
	(
		SW, KEY, LCD_DATA, LCD_EN, LCD_ON, LCD_RS, LCD_RW, LEDG, LEDR, CLOCK_50, HEX6, HEX7
	);
	
	input CLOCK_50;
	input [17:0] SW;
	input [3:0] KEY;
	output [7:0] LEDG;
	output [17:0] LEDR;
	output [7:0] LCD_DATA;
	output LCD_EN, LCD_RS, LCD_RW, LCD_ON;
	output [6:0] HEX6;
	output [6:0] HEX7;
	
	
	system interface
	(
		.LCD_CLK(CLOCK_50),
		.SYS_clk(KEY[0]),
		.SYS_rst(KEY[3]),
		.SYS_load(SW[9]),
		.SYS_pc_val(SW[17:10]), /// use SYS_load to load value into PC[8..0]
		.SYS_leds(LEDG[7:0]),
		.SYS_output_sel(SW[7:0]),
		.EH_led(LEDR[0]),
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