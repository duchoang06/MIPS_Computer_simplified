module control
	(
		input [5:0] opcode,
		output reg [10:0] control_signal
	);
	
	// parameterized control signals
	parameter Jump = 				1'b1;	// bit 10
	parameter Branch = 			1'b1;	// bit 9
	parameter MemRead = 			1'b1;	// bit 8
	parameter MemWrite = 		1'b1;	// bit 7
	parameter Mem2Reg = 			1'b1;	// bit 6
	parameter ALUop_io = 		2'b00;// bit 5-4
	parameter ALUop_branch =	2'b01;
	parameter ALUop_R = 			2'b10;
	parameter ALUop_I = 			2'b11;
	parameter Exception =		1'b1;	// bit 3
	parameter ALUsrc = 			1'b1;	// bit 2
	parameter RegWrite = 		1'b1;	// bit 1
	parameter RegDst = 			1'b1;	// bit 0
	
	// parameterized opcode for instructions
	parameter add = 6'd0;
	parameter _nor = 6'd0;
	parameter _or = 6'd0;
	parameter slt = 6'd0;
	parameter sll = 6'd0;
	parameter sltu = 6'd0;
	parameter srl = 6'd0;
	parameter sub = 6'd0;
	parameter jr = 6'd0;
	parameter _xor = 6'd0;
	parameter addi = 6'd8;
	parameter lw = 6'd35;
	parameter sw = 6'd43;
	parameter j = 6'd2;
	parameter jal = 6'd3;
	parameter beq = 6'd4;
	parameter bne = 6'd5;
	parameter slti = 6'd10;
	parameter sltiu = 6'd11;
	parameter andi = 6'd12;
	parameter ori = 6'd13;
	parameter lui = 6'd15;
	parameter lbu = 6'd36;
	parameter lhu = 6'd37;
	parameter sb = 6'd40;
	parameter sh = 6'd41; // checking for not listed opcode
	// parameter lb = 6'd??;
	
	// behavioral
	always @(opcode) begin // lui
		case(opcode)
		add, sub, _xor, _or, _nor, slt, sltu, sll, srl: control_signal = {~Jump, ~Branch, ~MemRead, ~MemWrite, ~Mem2Reg, ALUop_R, ~Exception, ~ALUsrc, RegWrite, RegDst};
		lw, lbu, lhu: control_signal = {~Jump, ~Branch, MemRead, ~MemWrite, Mem2Reg, ALUop_io, ~Exception, ALUsrc, RegWrite, ~RegDst};
		sw, sb, sh: control_signal = {~Jump, ~Branch, ~MemRead, MemWrite, ~Mem2Reg, ALUop_io, ~Exception, ALUsrc, ~RegWrite, ~RegDst};
		andi, ori, addi: control_signal = {~Jump, ~Branch, ~MemRead, ~MemWrite, ~Mem2Reg, ALUop_I, ~Exception, ALUsrc, RegWrite, RegDst};
		jr: control_signal = {Jump, ~Branch, ~MemRead, MemWrite, ~Mem2Reg, 2'bx, ~Exception, ~ALUsrc, RegWrite, RegDst};
		j: control_signal = {Jump, ~Branch, ~MemRead, ~MemWrite, ~Mem2Reg, 2'bx, ~Exception, ~ALUsrc, ~RegWrite, ~RegDst};
		bne, beq: control_signal = {~Jump, Branch, ~MemRead, ~MemWrite, ~Mem2Reg, ALUop_branch, ~Exception, ~ALUsrc, ~RegWrite, ~RegDst};
		//jal: control_signal = {Jump, ~Branch, ~MemRead, ~MemWrite, ~Mem2Reg, 2'bx, ~Exception, ~ALUsrc, ~RegWrite, ~RegDst};
		slti, slti: control_signal = {~Jump, ~Branch, ~MemRead, ~MemWrite, ~Mem2Reg, 2'bx, ~Exception, ALUsrc, RegWrite, RegDst}; // ALUsrc
		//lui: control_signal = {~Jump, ~Branch, ~MemRead, ~MemWrite, ~Mem2Reg, ALUop_I, ~Exception, ALUsrc, RegWrite, RegDst};
		
		default: control_signal = control_signal;
		endcase
	end

endmodule 

/* Modifications to prototype notes:
	#1: output -> output reg	
*/