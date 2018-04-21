module REG
	(
		input [5:0] REG_address1,
		input [5:0] REG_address2,
		input [5:0] REG_address_wr,
		input REG_write_1,
		input [31:0] REG_data_wr_in1,
		output reg [31:0] REG_data_out1,
		output reg [31:0] REG_data_out2
	);

	reg [31:0] REG_mem [31:0];
	
	always @(REG_address1, REG_address2, REG_address_wr, REG_write_1) begin
		if (REG_write_1) begin
			REG_mem[REG_address_wr] <= REG_data_wr_in1; 
		end
		else begin
			REG_data_out1 <= REG_mem[REG_address1];
			REG_data_out2 <= REG_mem[REG_address2];
		end
	end
	

endmodule 