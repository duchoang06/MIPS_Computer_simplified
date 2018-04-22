module SLL2 
	(
		input [31:0] SLL2_in,
		output [31:0] SLL2_out
	);
	
	assign SLL2 = SLL2_in << 2;
	
endmodule 