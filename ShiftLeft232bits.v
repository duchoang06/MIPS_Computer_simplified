module ShiftLeft232bits
	(
		input [31:0] Data_in,
		output [31:0] Data_out
	);
	
	assign Data_out [31:0] = {Data_in[29:0], 2'b00};
	
endmodule
