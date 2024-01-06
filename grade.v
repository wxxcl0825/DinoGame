`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:43:53 01/05/2024 
// Design Name: 
// Module Name:    grade 
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
module grade(input clk,
                input rstn,
                output [31:0]bcdgrade
                 );
    reg [20:0]grade = 21'd0;
    reg [31:0]count = 32'd0;
    always @(posedge clk)
    begin
        count <= count + 32'd1;
        if(rstn)
        begin
            grade <= 21'd0;
        end
        if(count>32'd50000000)
        begin
            count <= 32'd0;
            grade <= grade + 21'd1;
        end
    end
    assign bcdgrade[3:0] = grade%10;
    assign bcdgrade[7:4] = grade/10%10;
    assign bcdgrade[11:8] = grade/100%10;
    assign bcdgrade[15:12] = grade/1000%10;
    assign bcdgrade[19:16] = 4'b0;
    assign bcdgrade[23:20] = 4'b0;
    assign bcdgrade[27:24] = 4'b0;
    assign bcdgrade[31:28] = 4'b0;  
endmodule






