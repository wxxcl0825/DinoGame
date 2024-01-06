`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:21:30 01/05/2024 
// Design Name: 
// Module Name:    ctrl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ctrl(input clk,
                input restart,
                input crash,
                output show,
                output jump
                 );
  reg crash_flag=1'b1;
  reg show=1'b0;
  reg jump=1'b0;
  reg [31:0]count = 32'd0;
  always @(posedge clk)
  begin
    if(crash)
    begin
      crash_flag = 1'b1;    
      show = 1'b1;
    end
	 if(restart && crash_flag)
	 begin
		 crash_flag = 1'b0;
		 jump = 1'b1;
		 count = 32'd1;
	 end
	 if(count>32'd0)
	 begin
		 count = count + 32'd1;
		 if(count>32'd1000)
		 begin
			jump = 1'b0;
		 end
		 if(count>32'd50000000)
		 begin
			count = 32'd0;
			show = 1'b0;
		 end
     end
  end
endmodule




