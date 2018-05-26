module ALU
	(
		input [3:0] ALU_ctrl,
		input [31:0] ALU_operand_1,
		input [31:0] ALU_operand_2,
		input [4:0] shamnt,
		output reg [31:0] ALU_result,
		output reg [7:0] ALU_status
	);
	
	initial ALU_status = 8'b0000_0000;
	initial ALU_result = 32'd0;
	reg [32:0] result_temp; 
	
	always @(ALU_ctrl) begin
		case (ALU_ctrl) 
		4'b0010: begin
						ALU_result = ALU_operand_1 + ALU_operand_2;
						result_temp = ALU_operand_1 + ALU_operand_2;
					end
		4'b0110: ALU_result = ALU_operand_1 - ALU_operand_2;
		4'b0000: ALU_result = ALU_operand_1 & ALU_operand_2; // and
		4'b0001: ALU_result = ALU_operand_1 | ALU_operand_2; // or
		4'b0111: ALU_result = (ALU_operand_1 < ALU_operand_2) ? 32'd1 : 32'd0;
		4'b1100: ALU_result = ~(ALU_operand_1 | ALU_operand_2); // nor
		//4'b1000: ALU_result = ALU_operand_1 * ALU_operand_2; // mul
		//4'b1001: ALU_result = ALU_operand_1 / ALU_operand_2; // div
		4'b1010: ALU_result = ALU_operand_1 ^ ALU_operand_2; // xor
		//4'b1110: ALU_result = ALU_operand_1 << shamnt;
		//4'b1111: ALU_result = ALU_operand_1 >> shamnt;
		default: ALU_result = 32'd0;
		endcase
	end

	always @(*) begin
		if (ALU_result == 0) begin // zero
			ALU_status[7] = 1'b1;
		end
		else begin
			ALU_status[7] = 1'b0;	
		end
		/////////////////////////////////////
		
		if ((ALU_operand_1[31] == 0 && ALU_operand_2[31] == 0 &&  ALU_result[31] == 1 && ALU_ctrl == 4'b0010)
		|| (ALU_operand_1[31] == 1 && ALU_operand_2[31] == 1 &&  ALU_result[31] == 0 && ALU_ctrl == 4'b0010)
		|| (ALU_operand_1[31] == 0 && ALU_operand_2[31] == 1 &&  ALU_result[31] == 1 && ALU_ctrl == 4'b0110)
		|| (ALU_operand_1[31] == 1 && ALU_operand_2[31] == 0 &&  ALU_result[31] == 0 && ALU_ctrl == 4'b0110)
		// multiplication overflow handler
		|| (ALU_operand_1[31] == 1 && ALU_operand_2[31] == 0 &&  ALU_result[31] == 0 && ALU_ctrl == 4'b1000)
		|| (ALU_operand_1[31] == 0 && ALU_operand_2[31] == 1 &&  ALU_result[31] == 0 && ALU_ctrl == 4'b1000)
		|| (ALU_operand_1[31] == 0 && ALU_operand_2[31] == 0 &&  ALU_result[31] == 1 && ALU_ctrl == 4'b1000)
		|| (ALU_operand_1[31] == 1 && ALU_operand_2[31] == 1 &&  ALU_result[31] == 0 && ALU_ctrl == 4'b1000)		
		) begin // overflow
			ALU_status[6] = 1'b1;
		end
		else begin
			ALU_status[6] = 1'b0;	
		end
		/////////////////////////////
		
		if (result_temp[32]) begin // carry
			ALU_status[5] = 1'b1;
		end
		else begin
			ALU_status[5] = 1'b0;	
		end
		//////////////////////////////////
		
		if (ALU_result[31] == 1'b1) begin // negative
			ALU_status[4] = 1'b1;
		end
		else begin
			ALU_status[4] = 1'b0;	
		end
		/////////////////////////////////
		
		if (!(ALU_result % 2 == 0 || ALU_result % 4 == 0)) begin
			ALU_status[3] = 1'b1;
		end
		else begin
			ALU_status[3] = 1'b0;	
		end
		/////////////////////////////////
		
		if ((ALU_ctrl == 4'b1001) && (ALU_operand_2 == 32'd0)) begin // divide by zero
			ALU_status[2] = 1'b1;
		end
		else begin
			ALU_status[2] = 1'b0;	
		end
		
	end
	
	// log: complete
	
endmodule 