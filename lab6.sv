//////////////////////////////////////////////////////////////////////////////////
// Company:        Oregon State University
// Student:       Tristan Luther
// 
// Create Date:    06/04/2019 
// Design Name:    lab6.sv
// Module Name:    lab6.sv 
// Project Name:   
// Target Devices: DE-10 MAX10 
// Tool versions:  Quartus Prime Lite Edition
// Description:    Top Level for VGA display showing 80x60 image file.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module lab6(
	input CLK,
	output HS,
	output VS,
	output [3:0] RED,
	output [3:0] GREEN,
	output [3:0] BLUE
	);
	
	logic [1:0] q;
	logic [20:0] mem[19199:0]; //160 x 120 (8x8 pixels on 640x480)
	logic [20:0] mem_index;
	logic [7:0] color;
	logic [9:0] x, y;
	
	//Hexadecimal will be read as #FF_FF_FF (#red_green_blue)
	
	initial
	begin
		$readmemh("moore.txt", mem); //Hexadecimal file to read from, file contains hex color codes from (0,0) to (640,480)
	end
	
	counter c(.clk (CLK), .reset (1'b0), .q (q)); //Create an istance of the counter block to slow down the clock from 50MHz to 25MHz (needed for refreash rate)
	 
	vga v(.CLK (q[0]), .HS (HS), .VS (VS), .x (x), .y (y), .blank (blank));
	
	assign mem_index = (y/4)*160+x/4; //Give the index in memory based on how far along x and y are
	assign color = mem[mem_index]; //Give the color based on the adjusted location (to acccount for 160x120 size)
	//assign RED = ((x >200) & (x < 400) & (y > 200) & (y < 400)?7:0);
	//assign GREEN = 0;
	//assign BLUE = 0;
	assign RED = (blank?0:color[7:5]); //If the x,y location is not blank then output the color at that point.
	assign GREEN = (blank?0:color[4:2]);
	assign BLUE = (blank?0:color[1:0]);
	
endmodule
