module Exception_Handle
	(
		input EH_overflow,
		input EH_Invalid_addr,
		input EH_Div_zero,
		input EH_control,
		output reg EH_flag
	);
	
	always @(EH_overflow, EH_Invalid_addr, EH_Div_zero, EH_control) begin
		if (EH_overflow || EH_Invalid_addr || EH_Div_zero) begin
			EH_flag <= 1'b1;
		end
	end
	
endmodule 