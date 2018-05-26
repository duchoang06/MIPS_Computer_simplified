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
	parameter addi = 6'd8;
	parameter lw = 6'd35;
	parameter sw = 6'd43;
	parameter j = 6'd2;
	parameter beq = 6'd4;
	parameter bne = 6'd5;
	parameter slti = 6'd10;
	parameter andi = 6'd12;
	parameter ori = 6'd13;
	parameter sb = 6'd40;

	
	initial control_signal = 11'd0;
	
	always @(opcode) begin
		case(opcode)
		// R-type
		6'd0: control_signal = {~Jump, ~Branch, ~MemRead, ~MemWrite, ~Mem2Reg, ALUop_R, ~Exception, ~ALUsrc, RegWrite, RegDst};
		
		// lw
		lw: control_signal = {~Jump, ~Branch, MemRead, ~MemWrite, Mem2Reg, ALUop_io, ~Exception, ALUsrc, RegWrite, ~RegDst};
		
		// sw
		sw: control_signal = {~Jump, ~Branch, ~MemRead, MemWrite, ~Mem2Reg, ALUop_io, ~Exception, ALUsrc, ~RegWrite, ~RegDst};
		
		// addi, andi, ori
		addi: control_signal = {~Jump, ~Branch, ~MemRead, ~MemWrite, ~Mem2Reg, ALUop_io, ~Exception, ALUsrc, RegWrite, RegDst};
		
		j: control_signal = {Jump, ~Branch, ~MemRead, ~MemWrite, ~Mem2Reg, 2'bx, ~Exception, ~ALUsrc, ~RegWrite, ~RegDst};
		
		// bne:
		bne: control_signal = {~Jump, Branch, ~MemRead, ~MemWrite, ~Mem2Reg, ALUop_branch, ~Exception, ~ALUsrc, ~RegWrite, ~RegDst};
		
		// beq:
		beq: control_signal = {~Jump, Branch, ~MemRead, ~MemWrite, ~Mem2Reg, ALUop_branch, ~Exception, ~ALUsrc, ~RegWrite, ~RegDst};
	
		// sll
		//sll: control_signal = {~Jump, ~Branch, ~MemRead, ~MemWrite, ~Mem2Reg, ALUop_R, ~Exception, ALUsrc, RegWrite, RegDst};
		
		// srl
		//srl: control_signal = {~Jump, ~Branch, ~MemRead, ~MemWrite, ~Mem2Reg, ALUop_R, ~Exception, ALUsrc, RegWrite, RegDst};
		default: control_signal = 11'd0;
		endcase
	end

endmodule 
