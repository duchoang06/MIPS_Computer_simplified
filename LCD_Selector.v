module LCD_Selector
	(
		PC,IMEM_data, REG_data, ALU_data, ALU_status_data, DMEM_data, control_data, ALU_control_data, EPC_data output_sel,
		ox1, ox2, ox3, ox4, ox5, ox6, ox7, ox8, oy, oz1, oz2, oz3, oz4, oz5, oz6, oz7, oz8
	);
	
	input [31:0] PC, IMEM_data, REG_data, ALU_data, ALU_status_data, DMEM_data, control_data, ALU_control_data, EPC_data;
	input [7:0] output_sel;
	output reg [3:0] ox1, ox2, ox3, ox4, ox5, ox6, ox7, ox8, oy, oz1, oz2, oz3, oz4, oz5, oz6, oz7, oz8;
	
	always @(output_sel) begin 
		case (output_sel)
			8'b0000_0001:
				begin
					oy = 4'd0;
					oz1 = IMEM_data[3:0];
					oz2 = IMEM_data[7:4];
					oz3 = IMEM_data[11:8];
					oz4 = IMEM_data[15:12];
					oz5 = IMEM_data[19:16];
					oz6 = IMEM_data[23:20];
					oz7 = IMEM_data[27:24];
					oz8 = IMEM_data[31:28];
				end
			8'b0000_0010:
				begin
					oy = 4'd1;
					oz1 = REG_data[3:0];
					oz2 = REG_data[7:4];
					oz3 = REG_data[11:8];
					oz4 = REG_data[15:12];
					oz5 = REG_data[19:16];
					oz6 = REG_data[23:20];
					oz7 = REG_data[27:24];
					oz8 = REG_data[31:28];
				end
			8'b0000_0100:
				begin
					oy = 4'd2;
					oz1 = ALU_data[3:0];
					oz2 = ALU_data[7:4];
					oz3 = ALU_data[11:8];
					oz4 = ALU_data[15:12];
					oz5 = ALU_data[19:16];
					oz6 = ALU_data[23:20];
					oz7 = ALU_data[27:24];
					oz8 = ALU_data[31:28];
				end
			8'b0000_1000:
				begin
					oy = 4'd3;
					oz1 = ALU_status_data[3:0];
					oz2 = ALU_status_data[7:4];
					oz3 = ALU_status_data[11:8];
					oz4 = ALU_status_data[15:12];
					oz5 = ALU_status_data[19:16];
					oz6 = ALU_status_data[23:20];
					oz7 = ALU_status_data[27:24];
					oz8 = ALU_status_data[31:28];
				end
			8'b0001_0000:
				begin
					oy = 4'd4;
					oz1 = DMEM_data[3:0];
					oz2 = DMEM_data[7:4];
					oz3 = DMEM_data[11:8];
					oz4 = DMEM_data[15:12];
					oz5 = DMEM_data[19:16];
					oz6 = DMEM_data[23:20];
					oz7 = DMEM_data[27:24];
					oz8 = DMEM_data[31:28];
				end
			8'b0010_0000:
				begin
					oy = 4'd5;
					oz1 = control_data[3:0];
					oz2 = control_data[7:4];
					oz3 = control_data[11:8];
					oz4 = control_data[15:12];
					oz5 = control_data[19:16];
					oz6 = control_data[23:20];
					oz7 =	control_data[27:24];
					oz8 = control_data[31:28];
				end
			8'b0100_0000:
				begin
					oy = 4'd6;
					oz1 = ALU_control_data[3:0];
					oz2 = ALU_control_data[7:4];
					oz3 = ALU_control_data[11:8];
					oz4 = ALU_control_data[15:12];
					oz5 = ALU_control_data[19:16];
					oz6 = ALU_control_data[23:20];
					oz7 = ALU_control_data[27:24];
					oz8 = ALU_control_data[31:28];
				end
			8'b1000_0000:
				begin
					oy = 4'd7;
					oz1 = EPC_data[3:0];
					oz2 = EPC_data[7:4];
					oz3 = EPC_data[11:8];
					oz4 = EPC_data[15:12];
					oz5 = EPC_data[19:16];
					oz6 = EPC_data[23:20];
					oz7 = EPC_data[27:24];
					oz8 = EPC_data[31:28];
				end		
		default:
			begin
					oy = 4'd0;
					oz1 = 4'd0;
					oz2 = 4'd0;
					oz3 = 4'd0;
					oz4 = 4'd0;
					oz5 = 4'd0;
					oz6 = 4'd0;
					oz7 = 4'd0;
					oz8 = 4'd0;
				end
		endcase
	end
	
	always @(PC) begin
		ox1 = PC[3:0];
		ox2 = PC[7:4];
		ox3 = PC[11:8];
		ox4 = PC[15:12];
		ox5 = PC[19:16];
		ox6 = PC[23:20];
		ox7 = PC[27:24];
		ox8 = PC[31:28];
	end
	
	
endmodule 
