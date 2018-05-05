module IMEM
	(
		input [7:0] IMEM_PC, // Address of desired instructions
		output reg [31:0] IMEM_instruction, // Instructions to be fetched
		input IMEM_clk
	);
	
	reg [31:0] IMEM_mem [0:255]; // a word

	// load instructions from file
	initial begin
		$readmemb("IMEM_mem.bin", IMEM_mem);
		IMEM_PC = 8'd0;
	end

	always @(posedge IMEM_clk) begin
		IMEM_instruction <= IMEM_mem[IMEM_PC];
	end
endmodule 


/* Modifications to prototype notes:
	#1: output -> output reg
	
	
*/