module LED7SEG_decoder
	(	 
		iDIG,								 
		oHEX_D		
	);


// reg - wire declaration
input iDIG;				 
output [6:0] oHEX_D;   
reg [6:0] oHEX_D;	

// behavior controlling
always @(iDIG) 
        begin
			case(iDIG)
			1'b0: oHEX_D <= 7'b1000000; //0  
			1'b1: oHEX_D <= 7'b1111001; //1
	     default: oHEX_D <= 7'b1000000; //0
			endcase
end

endmodule 