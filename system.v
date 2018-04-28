/*
PIN Assignments:
SYS_clk: CLK50;
SYS_rst: KEY[0];
SYS_load: KEY[1];
SYS_pc_val: SW[7:0]
SYS_output_sel: SW[14:8] or via IR.
SYS_leds: LEDG, LEDR.
SYS_hex0: HEX[0]
....
SYS_hex7: HEX[7]
*/

module system
	(
		input SYS_clk,
		input SYS_rst,
		input SYS_load,
		input [7:0] SYS_pc_val, /// use SYS_load to load value into PC[8..0]
		output [7:0] SYS_leds,
		
		input [7:0] SYS_output_sel,
		
		// LCD module
		output [7:0] LCD_DATA,
		output LCD_ON,
		output LCD_RS, 
		output LCD_RW,
		output LCD_EN
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
	
	assign SYS_clk = EH_flag ? 0 : SYS_clk;
	
	assign PC_f = (!SYS_load) ? SYS_pc_val : PC;			// Actually do we need this? 
	
	wire [7:0] PC_f;
	IMEM
	(
		.IMEM_PC(PC_f),
		.IMEM_instruction(instruction),
		.IMEM_clk(SYS_clk)
	);
	
	REG
	(
		.REG_address1(instruction[25:21]),
		.REG_address2(instruction[20:16]),
		.REG_address_wr(instruction[15:11]),
		.REG_write_1(Reg_Write),
		.REG_data_wr_in1(Data_Write),
		.REG_data_out1(Reg_Out1),
		.REG_data_out2(Reg_Out2),
		.REG_clk(SYS_clk)
	);
	
	wire [31:0] ALU_operand_2;
	ALU
	(
		.ALU_ctrl(ALU_control),
		.ALU_operand_1(Reg_Out_1),
		.ALU_operand_2(ALU_operand_2),
		.ALU_result(ALU_result),
		.ALU_status(ALU_status)
	);
	
	DMEM
	(
		.DMEM_address(ALU_result[7:0]), 
		.DMEM_data_in(Reg_Out2),
		.DMEM_mem_write(Mem_Write_f),
		.DMEM_mem_read(Mem_Read_f),
		.DMEM_clk(SYS_clk),
		.DMEM_data_out(Mem_Out)
	);
	
	control
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
	
	ALU_control 
	(
		.ALU_control_opcode(ALU_op),
		.ALU_control_funct(instruction[5:0]),
		.ALU_control_out(ALU_control)
	);

	Exception_Handle
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
	
	// Selection between ALU_result and Mem_out
	assign Data_Write = (Mem2Reg_f) ? Mem_out : ALU_result;
	
	// Selection between instruction[20:16] and [15:11]
	assign Reg_Write = (Reg_Dst) ? instruction[15:11] : instruction[20:16];
	
	wire [31:0] Sign_Ext_out;
	module Sign_Ext
	(
		.Sign_Ext_immediate(instruction[15:0]),
		.Sign_Ext_out(Sign_Ext_out)
	);
	
	// Selection between Reg_Out2 & Sign_Ext_out
	assign ALU_operand_2 = (ALU_src) ? Sign_Ext_out : Reg_Out2;
	
	// adder of PC+1 and Sign_Ext_out
	wire [7:0] sum2;
	assign sum2 = sum1 + Sign_Ext_out[7:0];  // ISSUE: whether or not using << 2 ?
	
	// adder of PC and 1
	wire [7:0] sum1;
	assign sum1 = PC + 1; 
	
	// adder of PC+1 and immediate_26, shorted to 8 bits
	wire [7:0] sum3;
	assign sum3 = sum1 + instruction[7:0];		// ISSUE: whether or not using << 2 ?
	
	// selection between PC+1 and sum2
	wire [7:0] w0;
	assign w0 = (and0) ? sum2 : sum1;

	// selection between w0 and sum3
	assign PC = (Jump) ? : sum3: w0;
	
	// and between Branch and ALU_status (Zero)
	wire and0;
	and and0, Branch, ALU_status[7];
	
	wire [7:0] EPC;
	EPC
	(
		.EPC_flag(EH_flag),
		.EPC_PC(PC),
		.EPC_PC_prev(EPC)
	);
	
	// LCD display
	reg [3:0] x1, x2, x3, x4, x5, x6, x7, x8, z1, z2, z3, z4, z5, z6, z7, z8, y;
	LCD_TEST 
	(	
		.iCLK(SYS_clk), .iRST_N(1'b1),
		.LCD_DATA(LCD_DATA), .LCD_RW(LCD_RW), .LCD_EN(LCD_EN), .LCD_RS(LCD_RS),
		.x1(x1), .x2(x), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8),
		.z1(z1), .z2(z2), .z3(z3), .z4(z4), .z5(z5), .z6(z7), .z7(z7), .z8(z8),
		.y(y)
	);
	
	// Select output to be displayed
	wire temp1;
	assign temp1 = {24'd0, ALU_status};
	wire temp2;
	assign temp2 = {21'd0, control_signal};
	wire temp3;
	assign temp3 = {28'd0, ALU_control};
	module LCD_Selector
	(
		.PC(PC), .IMEM_data(instruction), .REG_data(Reg_Out2), .ALU_data(ALU_result), .ALU_status_data(temp1), .DMEM_data(Mem_Out),
		.control_data(temp2), .ALU_control_data(temp3), .EPC_data(EPC), .output_sel(SYS_output_sel),
		.ox1(x1), .ox2(x2), .ox3(x3), .ox4(x4), .ox5(x5), .ox6(x6), .ox7(x7), .ox8(x8),
		.oy(y), .oz1(z1), .oz2(z2), .oz3(z3), .oz4(z4), .oz5(z5), .oz6(z6), .oz7(z7), .oz8(z8)
	);
	
endmodule

