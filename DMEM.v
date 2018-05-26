module DMEM
	(
		input [7:0] DMEM_address, // least significant 8-bit in/out
		input [31:0] DMEM_data_in,
		input DMEM_mem_write,
		input DMEM_mem_read,
		input DMEM_clk,
		output [31:0] DMEM_data_out
	);
	
	reg [31:0] DMEM_mem [0:10]; // 10 initialized words 

	initial begin
		$readmemh("DMEM_mem.hex", DMEM_mem);
	end

	assign DMEM_data_out = DMEM_mem_read ? DMEM_mem[DMEM_address] : 32'd0;
	
	always @(posedge DMEM_clk) begin
		if (DMEM_mem_write) begin
			DMEM_mem[DMEM_address] <= DMEM_data_in;
		end
	end

endmodule 
