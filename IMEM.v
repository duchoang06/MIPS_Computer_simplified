module IMEM
	(
		input [7:0] IMEM_PC, // Address of desired instructions
		output [31:0] IMEM_instruction // Instructions to be fetched
	);
	
	reg [31:0] IMEM_mem [0:20]; // 20 instructions in total

	// load instructions from file
	initial begin
		$readmemb("Test1.txt", IMEM_mem);
	end
	
	assign IMEM_instruction = IMEM_mem[IMEM_PC];
endmodule 

