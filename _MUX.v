module _MUX
	(
		input [31:0] MUX_sel_0,
		input [31:0] MUX_sel_1,
		input MUX_sel,
		output [31:0] MUX_result
	);
	
	assign MUX_result = (MUX_sel) ? MUX_sel_1 : MUX_sel_0;
	
endmodule 