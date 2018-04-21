module DMEM
	(
		input [31:0] DMEM_address, // least significant 8-bit in/out
		input [31:0] DMEM_data_in,
		input DMEM_mem_write,
		input DMEM_mem_read,
		input DMEM_clk,
		output reg [31:0] DMEM_data_out
	);
	
	reg [31:0] DMEM_mem [0:255];
	
	always @(posedge DMEM_clk) begin
		if (DMEM_mem_write) begin
			DMEM_mem[DMEM_address[7:0]] <= DMEM_data_in;
		end
		else if (DMEM_mem_read) begin
			DMEM_data_out <= DMEM_mem[DMEM_address[7:0]];
		end
		else begin end
	end

endmodule 

/* Modifications to prototype notes:
	#1: output -> output reg
	#2: clk added
	
*/