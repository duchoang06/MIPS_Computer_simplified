module EPC
	(
		input EPC_flag,
		input [7:0] EPC_PC,
		output reg [7:0] EPC_PC_eh
	);
	
	always @(EPC_flag) begin
		if (EPC_flag) begin
			EPC_PC_eh = EPC_PC;
		end
		else begin
			EPC_PC_eh = 8'd0;
		end
	end
	
endmodule 