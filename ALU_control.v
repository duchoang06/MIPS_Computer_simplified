module ALU_control 
	(
		input [1:0] ALU_control_opcode,
		input [5:0] ALU_control_funct,
		output reg [3:0] ALU_control_out,
		output lw_signal
	);

	always @(ALU_control_opcode, ALU_control_funct) begin
		if (ALU_control_opcode == 2'b00 && ALU_control_funct == 6'dx) begin // add for lw/sw, addi
			ALU_control_out = 4'b0010;
		end
		else if (ALU_control_opcode == 2'b01 && ALU_control_funct == 6'dx) begin // sub for branch
			ALU_control_out = 4'b0110;
		end
		else if (ALU_control_opcode == 2'b10 && ALU_control_funct == 6'b100_000) begin // add for R
			ALU_control_out = 4'b0010;
		end
		else if (ALU_control_opcode == 2'b10 && ALU_control_funct == 6'b100_010) begin // sub for R
			ALU_control_out = 4'b0110;
		end
		else if (ALU_control_opcode == 2'b10 && ALU_control_funct == 6'b100_100) begin // and for R
			ALU_control_out = 4'b0000;
		end
		else if (ALU_control_opcode == 2'b10 && ALU_control_funct == 6'b100_101) begin // or for R
			ALU_control_out = 4'b0001;
		end
		//else if (ALU_control_opcode == 2'b10 && ALU_control_funct == 6'b101_010) begin // sub for R
		//	ALU_control_out = 4'b0111;
		//end
		//else if (ALU_control_opcode == 2'b10 && ALU_control_funct == 6'b110_000) begin // mult for R
		//	ALU_control_out = 4'b1000;
		//end
		//else if (ALU_control_opcode == 2'b10 && ALU_control_funct == 6'b110_001) begin // div for R
		//	ALU_control_out = 4'b1001;
		//end
		else if (ALU_control_opcode == 2'b10 && ALU_control_funct == 6'b100_110) begin // xor for R
			ALU_control_out = 4'b1010;
		end
		else if (ALU_control_opcode == 2'b10 && ALU_control_funct == 6'b000_000) begin // sll for R
			ALU_control_out = 4'b1100;
		end
		else if (ALU_control_opcode == 2'b10 && ALU_control_funct == 6'b000_010) begin // srl for R
			ALU_control_out = 4'b1101;
		end
		else begin
			ALU_control_out = ALU_control_out;
		end
	
	end
	
	assign lw_signal = (ALU_control_opcode == 2'b00) ? 1'b1 : 1'b0;
	
endmodule 