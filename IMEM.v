module IMEM
	(
		input [7:0] IMEM_PC, // Address of desired instructions
		output reg [31:0] IMEM_instruction // Instructions to be fetch
	);
	
	reg [31:0] IMEM_mem [0:255];
	
	always @(IMEM_PC) begin
		IMEM_instruction <= IMEM_mem[IMEM_PC];
	end
endmodule 


/* Modifications to prototype notes:
	#1: output -> output reg
	
	
*/