module ADDER 
	(
		input [31:0] ADDER_operand_1,
		input [31:0] ADDER_operand_2,
		output [31:0] ADDER_sum
	);
	
	assign ADDER_sum = ADDER_operand_1 + ADDER_operand_2;
	
endmodule 