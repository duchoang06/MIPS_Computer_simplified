module Exception_Handle
	(
		input EH_overflow,
		input EH_Invalid_addr,
		input EH_Div_zero,
		input EH_control,
		input EH_write2_0,
		output reg EH_flag
	);
	
	initial EH_flag = 0;
	
	always @(EH_overflow, EH_Invalid_addr, EH_Div_zero, EH_control, EH_write2_0) begin
		if (EH_overflow || EH_Invalid_addr || EH_Div_zero || EH_control || EH_write2_0) begin
			EH_flag = 1'b1;
		end
		else begin
			EH_flag = 1'b0;
		end
	end
	
endmodule 