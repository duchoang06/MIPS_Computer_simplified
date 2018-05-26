// missing functions:
// - no pc loading from switch


module system
	(
		input SYS_clk,
		input SYS_rst,
		input SYS_load,
		input [7:0] SYS_pc_val, /// use SYS_load to load value into PC[8..0]
		input LCD_clk,
		
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

		output [6:0] hex6,
		output [6:0] hex7,
		
		output [17:0] ALU_result_leds
		);
	
	// controller wires
	wire Reg_Write, Mem_Write, Mem_Write_f, Mem_Read, Mem_Read_f, Reg_Dst, ALU_src, Exception, Mem2Reg, Jump, Branch, Mem2Reg_f;
	wire [3:0] ALU_control;
	wire [1:0] ALU_op;
	wire [7:0] ALU_status;
	wire EH_flag;
	
	// datapath wires
	//wire [7:0] PC;
	wire [31:0] instruction;
	wire [31:0] Data_Write;
	wire [31:0] Reg_Out1;
	wire [31:0] Reg_Out2;
	wire [31:0] ALU_result;
	wire [31:0] Mem_Out;
	wire [5:0] Write_Reg;
	
	// Notes:
	// EH_flag controlling needs adding
	// rst controlling missing
	
	// PC controlling
	
	
	// PC Load from switch LED indicator
	assign SYS_leds = SYS_pc_val;
	
	wire [7:0] PC_current;
	
	// assign ALU_result_leds = ALU_result[17:0];
						
	// Begin of sub-modules
	PC uPC
	(
		.PC_clk(SYS_clk),
		.PC_rst(SYS_rst),
		.PC_current(PC_current),
		.PC_next(PC_next)
	);	

	
	IMEM uIMEM
	(
		.IMEM_PC(PC_current),
		.IMEM_instruction(instruction)
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
		.REG_clk(clk_1)
	);
	
	wire [31:0] ALU_operand_2;
	ALU uALU
	(
		.ALU_ctrl(ALU_control),
		.ALU_operand_1(Reg_Out1),
		.ALU_operand_2(ALU_operand_2),
		.shamnt(instruction[10:6]),
		.ALU_result(ALU_result),
		.ALU_status(ALU_status)
	);
	
	clock_50_to_01 uclock_50_to_01
	(
		.clk_i(LCD_clk),
		.clk_o(clk_1)
	);
	
	wire clk_1;

	DMEM uDMEM
	(
		.DMEM_address(ALU_result), 
		.DMEM_data_in(Reg_Out2),
		.DMEM_mem_write(Mem_Write_f),
		.DMEM_mem_read(Mem_Read_f),
		.DMEM_clk(clk_1),
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
	
	wire lw_signal;
	ALU_control uALU_control
	(
		.ALU_control_opcode(ALU_op),
		.ALU_control_funct(instruction[5:0]),
		.ALU_control_out(ALU_control),
		.lw_signal(lw_signal)
	);

	wire write2_0;
	Exception_Handle uException_Handle
	(
		.EH_overflow(ALU_status[6]),
		.EH_Invalid_addr(ALU_status[3]),
		.EH_Div_zero(ALU_status[2]),
		.EH_control(Exception),
		.EH_write2_0(write2_0),
		.EH_flag(EH_flag)
	);
	
	// exception handler
	/*assign Mem2Reg_f = (EH_flag) ? 0 : Mem2Reg;
	assign Mem_Read_f = (EH_flag) ? 0 : Mem_Read;
	assign Mem_Write_f = (EH_flag) ? 0 : Mem_Write;*/
	
	assign Mem2Reg_f = Mem2Reg;
	assign Mem_Read_f = Mem_Read;
	assign Mem_Write_f = Mem_Write;
	
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
	
	// EH flag signals when write to $0
	assign write2_0 = (lw_signal && (Write_Reg == 0)) ? 1'b1 : 1'b0;
	
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
	
	// selection between 
	
	// and between Branch and ALU_status (Zero)
	wire and0;
	and (and0, Branch, ALU_status[7]);
	
	wire [7:0] EPC;
	EPC uEPC
	(
		.EPC_flag(EH_flag),
		.EPC_PC(PC_current),
		.EPC_PC_eh(EPC)
	);
	////////////////////////////////////////////
	//assign EH_flag = 0;
	
	
	
	// EPC indications
	assign hex7 = ( EH_flag ) ? 7'b_0000_110 : 7'b1111_111;
	assign hex6 = ( EH_flag ) ? 7'b_0001_001 : 7'b1111_111;
	
	
	// LCD display
	assign LCD_ON = 1'b1;
	wire [3:0] z1, z2, z3, z4, z5, z6, z7, z8, y;
	wire x1, x2, x3, x4, x5, x6, x7, x8;
	LCD_TEST uLCD_TEST
	(	
		.iCLK(LCD_clk), .iRST_N(1'b1),
		.LCD_DATA(LCD_DATA), .LCD_RW(LCD_RW), .LCD_EN(LCD_EN), .LCD_RS(LCD_RS),
		.x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8),
		.z1(z1), .z2(z2), .z3(z3), .z4(z4), .z5(z5), .z6(z7), .z7(z7), .z8(z8),
		.y(y)
	);
	
	// Select output to be displayed
	//wire [31:0] temp0;
	//assign temp0 = {24'd0, PC_current};
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
	
	

	LCD_Selector uLCD_selector
	(
		.PC(PC_current), .IMEM_data(instruction), .REG_data(Reg_Out2), .ALU_data(ALU_result), .ALU_status_data(temp1), .DMEM_data(Mem_Out),
		.control_data(temp2), .ALU_control_data(temp3), .EPC_data(temp4), .output_sel(SYS_output_sel),
		.ox1(x1), .ox2(x2), .ox3(x3), .ox4(x4), .ox5(x5), .ox6(x6), .ox7(x7), .ox8(x8),
		.oy(y), .oz1(z1), .oz2(z2), .oz3(z3), .oz4(z4), .oz5(z5), .oz6(z6), .oz7(z7), .oz8(z8)
	);
	
	
endmodule

