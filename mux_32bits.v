module mux_32bits
	(
		input [31:0] REG_in1,
		input [31:0] REG_in2,
		input sel,
		output [31:0] REG_out
	);
	
	assign REG_out = ~sel ? REG_in1 : REG_in2;
	
endmodule
