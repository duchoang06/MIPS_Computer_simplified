module	LCD_TEST (
					// controller
					iCLK,iRST_N,
					//	LCD out
					LCD_DATA,LCD_RW,LCD_EN,LCD_RS,
					// data in
					fs0, fs1, fm0, fm1, fh0, fh1);
					
// input
input			iCLK,iRST_N;
input [3:0] fs0, fs1, fm0, fm1, fh0, fh1;

// output
output	[7:0]	LCD_DATA;
output			LCD_RW,LCD_EN,LCD_RS;

// Internal wires and regs
reg	[5:0]	LUT_INDEX;
reg	[8:0]	LUT_DATA;
reg	[5:0]	mLCD_ST;
reg	[17:0]	mDLY;
reg			mLCD_Start;
reg	[7:0]	mLCD_DATA;
reg			mLCD_RS;
wire		mLCD_Done;

// Constant
parameter	LCD_INTIAL	=	0;
parameter	LCD_LINE1	=	5;
parameter	LCD_CH_LINE	=	LCD_LINE1+16;
parameter	LCD_LINE2	=	LCD_LINE1+16+1;
parameter	LUT_SIZE	=	LCD_LINE1+32+1;


always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		LUT_INDEX	<=	0;
		mLCD_ST		<=	0;
		mDLY		<=	0;
		mLCD_Start	<=	0;
		mLCD_DATA	<=	0;
		mLCD_RS		<=	0;
	end
	else
	begin
		if(LUT_INDEX<LUT_SIZE)
		begin
			case(mLCD_ST)
			0:	begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
			1:	begin
					if(mLCD_Done)
					begin
						mLCD_Start	<=	0;
						mLCD_ST		<=	2;					
					end
				end
			2:	begin
					if(mDLY<18'h3FFFE)
					mDLY	<=	mDLY+1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	3;
					end
				end
			3:	begin
					LUT_INDEX	<=	LUT_INDEX+1;
					mLCD_ST	<=	0;
				end
			endcase
		end
		else LUT_INDEX <= LCD_LINE1;
	end
end

always
begin
	case(LUT_INDEX)
	//	Initialization
	LCD_INTIAL+0:	LUT_DATA	<=	9'h038;
	LCD_INTIAL+1:	LUT_DATA	<=	9'h00C;
	LCD_INTIAL+2:	LUT_DATA	<=	9'h001;
	LCD_INTIAL+3:	LUT_DATA	<=	9'h006;
	LCD_INTIAL+4:	LUT_DATA	<=	9'h080;	
   //	Line 1
	LCD_LINE1+0:	LUT_DATA	<=	9'h154; // T
	LCD_LINE1+1:	LUT_DATA	<=	9'h169; // i 
	LCD_LINE1+2:	LUT_DATA	<=	9'h16D; // m
	LCD_LINE1+3:	LUT_DATA	<=	9'h165; // e
	LCD_LINE1+4:	LUT_DATA	<=	9'h13A; // :
	LCD_LINE1+5:	LUT_DATA	<=	9'h120; // <space>
   //	Change line
	LCD_CH_LINE:	LUT_DATA	<=	9'h0C0;
	//	Line 2
	LCD_LINE2+0:	LUT_DATA	<=	decoder(fh1);	//	fh1	
	LCD_LINE2+1:	LUT_DATA	<=	decoder(fh0);	// fh0
	LCD_LINE2+2:	LUT_DATA	<=	9'h13A;        // :
	LCD_LINE2+3:	LUT_DATA	<=	decoder(fm1);  // fm1
	LCD_LINE2+4:	LUT_DATA	<=	decoder(fm0);  // fm0
	LCD_LINE2+5:	LUT_DATA	<=	9'h13A;        // :
	LCD_LINE2+6:	LUT_DATA	<=	decoder(fs1);  // fs1
	LCD_LINE2+7:	LUT_DATA <= decoder(fs0);	// fs0
	default:		LUT_DATA	<=	9'h120;
	endcase
end

// timing & controlling
LCD_Controller 		u0	(
							.iDATA(mLCD_DATA),
							.iRS(mLCD_RS),
							.iStart(mLCD_Start),
							.oDone(mLCD_Done),
							.iCLK(iCLK),
							.iRST_N(iRST_N),
							//	
							.LCD_DATA(LCD_DATA),
							.LCD_RW(LCD_RW),
							.LCD_EN(LCD_EN),
							.LCD_RS(LCD_RS)	);
							
// decoder for BCD to HEX
function [8:0] decoder(input [3:0] BCD);
	decoder = ( BCD == 0 ) ? 9'b1_0011_0000 : 
				 (( BCD == 1 ) ? 9'b1_0011_0001 :
				 (( BCD == 2 ) ? 9'b1_0011_0010 :
				 (( BCD == 3 ) ? 9'b1_0011_0011 :
				 (( BCD == 4 ) ? 9'b1_0011_0100 :
				 (( BCD == 5 ) ? 9'b1_0011_0101 :
				 (( BCD == 6 ) ? 9'b1_0011_0110 :
				 (( BCD == 7 ) ? 9'b1_0011_0111 :
				 (( BCD == 8 ) ? 9'b1_0011_1000 :
				 (( BCD == 9 ) ? 9'b1_0011_1001 :
				 9'b1_0011_0000
				 )))))))));
endfunction

endmodule
