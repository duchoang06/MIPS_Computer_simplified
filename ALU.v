module ALU
	(
		input [3:0] ALU_ctrl,
		input [31:0] ALU_operand_1,
		input [31:0] ALU_operand_2,
		output [31:0] ALU_result,
		output [7:0] ALU_status
	);
	
	always @(ALU_ctrl) begin
		case (ALU_ctrl) 
		4'b0010: ALU_result = ALU_operand_1 + ALU_operand_2;
		4'b0110: ALU_result = ALU_operand_1 - ALU_operand_2;
		4'b0000: ALU_result = ALU_operand_1 & ALU_operand_2;
		4'b0001: ALU_result = ALU_operand_1 | ALU_operand_2;
		4'b0111: ALU_result = (ALU_operand_1 < ALU_operand_2)?32'd1:32'd0;
		4'b1100: ALU_result = ~(ALU_operand_1 | ALU_operand_2);
		// more
	
		default: ALU_result = 32'bx;
		endcase
	end

// no exceptions handler
	
endmodule 