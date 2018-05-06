module ShiftLeft226bits
	(
		input [25:0] Data_in,
		output [25:0] Data_out
	);
	
	assign Data_out [25:0] = {Data_in[23:0], 2'b00};
	
endmodule
