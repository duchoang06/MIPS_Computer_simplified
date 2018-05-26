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