`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:18:48 01/05/2024 
// Design Name: 
// Module Name:    speedup 
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
module speedup(input clk,
                input rstn,
                output [20:0]speed
                 );
    reg [20:0]speed;
    reg [31:0]count = 32'd0;
    always @(posedge clk)
    begin
        count = count + 32'd1;
        if(rstn)
        begin
            speed <= 21'd450000;
        end
        if(count>32'd500000000)
        begin
            count = 32'd0;
            speed <= speed - 21'd20000;
        end
    end
endmodule






