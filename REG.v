module REG
	(
		input [4:0] REG_address1,
		input [4:0] REG_address2,
		input [4:0] REG_address_wr,
		input REG_write_1,
		input [31:0] REG_data_wr_in1,
		output [31:0] REG_data_out1,
		output [31:0] REG_data_out2,
		input REG_clk 
	);

	reg [31:0] REG_mem [0:31];

	initial begin
			REG_mem[1] = 32'd0;
			REG_mem[2] = 32'd0;
			REG_mem[3] = 32'd0;
			REG_mem[4] = 32'd0;
			REG_mem[5] = 32'd0;
			REG_mem[6] = 32'd0;
			REG_mem[7] = 32'd0;
			REG_mem[8] = 32'd0;
			
			REG_mem[9] = 32'd0;
			REG_mem[10] = 32'd0;
			REG_mem[11] = 32'd0;
			REG_mem[12] = 32'd0;
			REG_mem[13] = 32'd0;
			REG_mem[14] = 32'd0;
			REG_mem[15] = 32'd0;
			REG_mem[16] = 32'd0;
			
			REG_mem[17] = 32'd0;
			REG_mem[18] = 32'd0;
			REG_mem[19] = 32'd0;
			REG_mem[20] = 32'd0;
			REG_mem[21] = 32'd0;
			REG_mem[22] = 32'd0;
			REG_mem[23] = 32'd0;
			REG_mem[24] = 32'd0;
			
			REG_mem[25] = 32'd0;
			REG_mem[26] = 32'd0;
			REG_mem[27] = 32'd0;
			REG_mem[28] = 32'd0;
			REG_mem[29] = 32'd0;
			REG_mem[30] = 32'd0;
			REG_mem[31] = 32'd0;
	end
	// register $0
	initial REG_mem[0] = 32'd0;
	                                                                                                                                                      
	
	assign REG_data_out1 = REG_mem[REG_address1];
	assign REG_data_out2 = REG_mem[REG_address2];
	
	always @(posedge REG_clk) begin
		if (REG_write_1) begin
			REG_mem[REG_address_wr] <= REG_data_wr_in1;
		end
	end
	

endmodule 