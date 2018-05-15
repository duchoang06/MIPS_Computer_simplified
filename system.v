module system
	(
		input SYS_clk,
		input SYS_rst,
		input SYS_load,
		input [7:0] SYS_pc_val, /// use SYS_load to load value into PC[8..0]
		input LCD_CLK,
		
		input [7:0] SYS_output_sel,		

		// LED indicator
		output [7:0] SYS_leds,
		output EH_led,
		
		// LCD module
		output [7:0] LCD_DATA,
		output LCD_ON,
		output LCD_RS, 
		output LCD_RW,
		output LCD_EN,
		output [6:0] hex0,
		output [6:0] hex1,
		output [6:0] hex2,
		output [6:0] hex3,
		output [6:0] hex4,
		output [6:0] hex5,
		output [6:0] hex6,
		output [6:0] hex7,
		output [17:1] ledr
		);
	
	// controller wires
	wire EH_flag, Reg_Write, Mem_Write, Mem_Read, Reg_Dst, ALU_src, Exception, Mem2Reg, Jump, Branch, Mem2Reg_f;
	wire [3:0] ALU_control;
	wire [1:0] ALU_op;
	wire [7:0] ALU_status;
	
	// datapath wires
	wire [7:0] PC;
	wire [31:0] instruction;
	wire [31:0] Data_Write;
	wire [31:0] Reg_Out1, Reg_Out2;
	wire [31:0] ALU_result;
	wire [31:0] Mem_Out;
	wire [5:0] Write_Reg;
	
	// Notes:
	// EH_flag controlling needs adding
	// rst controlling missing
	
	// PC controlling
	always @(posedge SYS_clk, negedge SYS_rst) begin
		if (!SYS_rst) begin
			PC_current <= 8'd0;
		end
		else begin
			PC_current <= PC_next;
		end
	end

	// Exception LED indicator
	assign EH_Led = EH_flag;
	
	// PC Load from switch LED indicator
	assign SYS_leds = SYS_pc_val;
	
	// Load PC from switch
	reg [7:0] PC_current;
	
	
						
	// Begin of sub-modules
	IMEM uIMEM
	(
		.IMEM_PC(PC_current),
		.IMEM_instruction(instruction),
		.IMEM_clk(SYS_clk)
	);
	
	REG uREG
	(
		.REG_address1(instruction[25:21]),
		.REG_address2(instruction[20:16]),
		.REG_address_wr(Write_Reg),
		.REG_write_1(Reg_Write),
		.REG_data_wr_in1(Data_Write),
		.REG_data_out1(Reg_Out1),
		.REG_data_out2(Reg_Out2),
		.REG_clk(SYS_clk)
	);
	
	wire [31:0] ALU_operand_2;
	ALU uALU
	(
		.ALU_ctrl(ALU_control),
		.ALU_operand_1(Reg_Out_1),
		.ALU_operand_2(ALU_operand_2),
		.ALU_result(ALU_result),
		.ALU_status(ALU_status)
	);
	
	DMEM uDMEM
	(
		.DMEM_address(ALU_result[7:0]), 
		.DMEM_data_in(Reg_Out2),
		.DMEM_mem_write(Mem_Write_f),
		.DMEM_mem_read(Mem_Read_f),
		.DMEM_clk(SYS_clk),
		.DMEM_data_out(Mem_Out)
	);
	
	control ucontrol
	(
		.opcode(instruction[31:26]),
		.control_signal(control_signal)
	);
	
	wire [10:0] control_signal;
	assign Reg_Dst = control_signal[0];
	assign Reg_Write = control_signal[1];
	assign ALU_src = control_signal[2];
	assign Exception = control_signal[3];
	assign ALU_op = control_signal[5:4];
	assign Mem2Reg = control_signal[6];
	assign Mem_Write = control_signal[7];
	assign Mem_Read = control_signal[8];
	assign Branch = control_signal[9];
	assign Jump = control_signal[10];
	
	ALU_control uALU_control
	(
		.ALU_control_opcode(ALU_op),
		.ALU_control_funct(instruction[5:0]),
		.ALU_control_out(ALU_control)
	);

	Exception_Handle uException_Handle
	(
		.EH_overflow(ALU_status[6]),
		.EH_Invalid_addr(ALU_status[3]),
		.EH_Div_zero(ALU_status[2]),
		.EH_control(Exception),
		.EH_flag(EH_flag)
	);
	
	// exception handler
	assign Mem2Reg_f = (EH_flag) ? 0 : Mem2Reg;
	assign Mem_Read_f = (EH_flag) ? 0 : Mem_Read;
	assign Mem_Write_f = (EH_flag) ? 0 : Mem_Write;
	
	// Selection between ALU_result and Mem_Out
	assign Data_Write = (Mem2Reg_f) ? Mem_Out : ALU_result;
	
	// Selection between instruction[20:16] and [15:11]
	assign Write_Reg = (Reg_Dst) ? instruction[15:11] : instruction[20:16];
	
	wire [31:0] Sign_Ext_out;
	Sign_Ext uSign_Ext
	(
		.Sign_Ext_immediate(instruction[15:0]),
		.Sign_Ext_out(Sign_Ext_out)
	);
	
	// Selection between Reg_Out2 & Sign_Ext_out
	assign ALU_operand_2 = (ALU_src) ? Sign_Ext_out : Reg_Out2;
	
	// adder of PC+1 and Sign_Ext_out
	wire [7:0] sum2;
	assign sum2 = sum1 + Sign_Ext_out[7:0];  // ISSUE: whether or not using << 2 ?
	
	
	
	
	
	wire [7:0] PC_next;
	// adder of PC and 1
	wire [7:0] sum1;
	assign sum1 = PC_current + 1; 
	
	// adder of PC+1 and immediate_26, shorted to 8 bits
	wire [7:0] sum3;
	assign sum3 = sum1 + instruction[7:0];		// ISSUE: whether or not using << 2 ?
	
	
	
	
	
	
	
	
	// selection between PC+1 and sum2
	wire [7:0] w0;
	assign w0 = (and0) ? sum2 : sum1;

	// selection between w0 and sum3
	assign PC_next = (Jump) ? sum3 : w0;
	
	// and between Branch and ALU_status (Zero)
	wire and0;
	and (and0, Branch, ALU_status[7]);
	
	wire [7:0] EPC;
	EPC uEPC
	(
		.EPC_flag(EH_flag),
		.EPC_PC(PC_current),
		.EPC_PC_prev(EPC)
	);
	
	// LCD display
	wire [3:0] x1, x2, x3, x4, x5, x6, x7, x8, z1, z2, z3, z4, z5, z6, z7, z8, y;
	LCD_TEST uLCD_TEST
	(	
		.iCLK(LCD_CLK), .iRST_N(1'b1),
		.LCD_DATA(LCD_DATA), .LCD_RW(LCD_RW), .LCD_EN(LCD_EN), .LCD_RS(LCD_RS),
		.x1(x1), .x2(x), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8),
		.z1(z1), .z2(z2), .z3(z3), .z4(z4), .z5(z5), .z6(z7), .z7(z7), .z8(z8),
		.y(y)
	);
	
	// Select output to be displayed
	wire [31:0] temp0;
	assign temp0 = {24'd0, PC_current};
	wire [31:0] temp1;
	assign temp1 = {24'd0, ALU_status};
	wire [31:0] temp2;
	assign temp2 = {21'd0, control_signal};
	wire [31:0] temp3;
	assign temp3 = {28'd0, ALU_control};
	wire [31:0] temp4;
	assign temp4 = {24'd0, EPC};
//	wire [31:0] temp5;
//	assign temp5 = {24'd0, SYS_output_sel};
	
	// HEX displays PC values
	LED7SEG_decoder u0
	(	 
		.iDIG(PC_current[0]),								 
		.oHEX_D(hex0)		
	);
	LED7SEG_decoder u1
	(	 
		.iDIG(PC_current[1]),								 
		.oHEX_D(hex1)		
	);
	LED7SEG_decoder u2
	(	 
		.iDIG(PC_current[2]),								 
		.oHEX_D(hex2)		
	);
	LED7SEG_decoder u3
	(	 
		.iDIG(PC_current[3]),								 
		.oHEX_D(hex3)		
	);
	LED7SEG_decoder u4
	(	 
		.iDIG(PC_current[4]),								 
		.oHEX_D(hex4)		
	);
	LED7SEG_decoder u5
	(	 
		.iDIG(PC_current[5]),								 
		.oHEX_D(hex5)		
	);
	LED7SEG_decoder u6
	(	 
		.iDIG(PC_current[6]),								 
		.oHEX_D(hex6)		
	);
	LED7SEG_decoder u7
	(	 
		.iDIG(PC_current[7]),								 
		.oHEX_D(hex7)		
	);
	
	
	// LEDR indicates selected values
	assign ledr = (SYS_output_sel[0] == 1) ? instruction[16:0] : 
					  (SYS_output_sel[1] == 1) ? Reg_Out2[16:0] :
					  (SYS_output_sel[2] == 1) ? ALU_result[16:0] :
					  (SYS_output_sel[3] == 1) ? temp1[16:0] :
					  (SYS_output_sel[4] == 1) ? Mem_Out[16:0] :
					  (SYS_output_sel[5] == 1) ? temp2[16:0] :
					  (SYS_output_sel[6] == 1) ? temp3[16:0] :
					  (SYS_output_sel[7] == 1) ? temp4[16:0] :
					  17'd0;
	
	LCD_Selector uLCD_selector
	(
		.PC(temp0), .IMEM_data(instruction), .REG_data(Reg_Out2), .ALU_data(ALU_result), .ALU_status_data(temp1), .DMEM_data(Mem_Out),
		.control_data(temp2), .ALU_control_data(temp3), .EPC_data(temp4), .output_sel(SYS_output_sel),
		.ox1(x1), .ox2(x2), .ox3(x3), .ox4(x4), .ox5(x5), .ox6(x6), .ox7(x7), .ox8(x8),
		.oy(y), .oz1(z1), .oz2(z2), .oz3(z3), .oz4(z4), .oz5(z5), .oz6(z6), .oz7(z7), .oz8(z8)
	);
	
endmodule

