module clock_50_to_01 (clk_i, clk_o);
	input clk_i;
	output reg clk_o;
	reg [24:0] count;
	
initial begin
	count = 0;
	clk_o = 0;
end

always @(posedge clk_i) begin
	if (count == 0) begin
		count <= 25'd24999999;
		clk_o <= ~clk_o;
	end
	else begin
		count <= count - 1;
	end
end
endmodule 