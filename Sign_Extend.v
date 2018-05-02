module Sign_Ext
	(
		input [15:0] Sign_Ext_immediate,
		output [31:0] Sign_Ext_out
	);
	
	wire [15:0] replication = {16{Sign_Ext_immediate[15]}};
	assign Sign_Ext_out = {replication, Sign_Ext_immediate};
	
endmodule 