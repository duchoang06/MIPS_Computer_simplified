module PC 
	(
		input PC_clk,
		input PC_rst,
		input [7:0] PC_next,
		output reg [7:0] PC_current
	);
	always @(posedge PC_clk, negedge PC_rst) begin
		if (!PC_rst) begin
			PC_current <= 8'd0;
		end
		else begin
			PC_current <= PC_next;
		end
	end
endmodule 