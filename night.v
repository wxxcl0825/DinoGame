`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:10:35 01/06/2024 
// Design Name: 
// Module Name:    night 
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
module night(input clk,
                input rstn,
                input [11:0]lastvga_data,
                output reg [11:0]vga_data
                 );
    reg [20:0]grade = 21'd0;
    reg [31:0]count = 32'd0;
    reg night = 1'b0;
    always @(posedge clk)
    begin
        count <= count + 32'd1;
        if(rstn)
        begin
            night <= 1'b0;
            grade <= 21'd0;
				count <= 32'd0;
        end
        if(count>32'd50000000)
        begin
            count <= 32'd0;
            grade <= grade + 21'd1;
        end
        if(grade>21'd50)
        begin
            grade <= 21'd0;
            night <= ~night;
        end
        if(night)
            vga_data <= ~lastvga_data;
        else vga_data <= lastvga_data;
    end
    
      
endmodule

