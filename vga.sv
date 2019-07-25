//////////////////////////////////////////////////////////////////////////////////
// Company:        Oregon State University
// Student:       Tristan Luther
// 
// Create Date:    06/04/2019 
// Design Name:    lab6.sv
// Module Name:    vga.sv 
// Project Name:   
// Target Devices: DE-10 MAX10 
// Tool versions:  Quartus Prime Lite Edition
// Description:    VGA driver
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module vga(
	input CLK,
	output HS, VS,
	output [9:0] x,
	output logic [9:0] y,
	output blank
	);
	
	logic [9:0] xc;
	                       
	//Horizontal Movement: 640 + HFP 16 + HS 96 + HBP 48 = 800 px
	//Vertical Movement: 480 + VFP 10 + VS 2 + VBP 33 = 525 px
	assign blank = ((xc < 160) | (xc > 800) | (y > 479)); //xc < 160 | xc > 800 | y > 479
	assign HS = ~ ((xc > 16) & (xc < 112)); //xc > 16 & xc < 112
	assign VS = ~ ((y > 490) & (y < 492)); //(y > 491) & (y < 494)
	assign x = ((xc < 160)?0:(xc - 160)); //(xc < 160)?0:(xc - 160)
	
	always_ff@(posedge CLK)
	begin
		//Pixel Counter
		if (xc == 800)
		begin
			xc <= 0;
			y <= y + 1;
		end
		else
		begin
			xc <= xc + 1;
		end
		if (y == 525)
		begin
			y <= 0;
		end
	end
endmodule
