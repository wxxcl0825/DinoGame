`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    22:04:12 12/06/2016
// Design Name:
// Module Name:    VGADEMO
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
module dinosaur(input clk,
                  input jump,
                  input [11:0]lastvga_data,
                  input rstn,
                  input [8:0]row,
                  input [9:0]col,
                  output [11:0]vga_data,
                  output reg [9:0]x,
                  output reg [8:0]y
                 );
  reg [11:0]vga_data;
  wire [9:0]col_add;
  wire [8:0]row_add;
  assign col_add = 9'd16 - col + x;
  assign row_add = 9'd16 - y + row;
  reg [15:0] rom_data [0:15] = {
        16'b0000000000000000,
        16'b0000000001111100,
        16'b0000000011111110,
        16'b0000000011011110,
        16'b0000000011111110,
        16'b0000000111110000,
        16'b0000001111111100,
        16'b0111111111100000,
        16'b0111111111000000,
        16'b0011111111110000,
        16'b0011111111010000,
        16'b0001111111000000,
        16'b0000110110000000,
        16'b0000010010000000,
        16'b0000011011000000,
        16'b0000000000000000};

  reg tmp;
  always @(*)
  begin
    if(rstn)
    begin
      x<=10'd320;
      y<=9'd240;
    end
    if(col_add < 10'd16 && row_add<9'd16 )
    begin
      tmp = rom_data[row_add][col_add];
      if(tmp)
      begin
        vga_data <= 12'h0f0;
      end
      else
      begin
        vga_data <= 12'hf00;
      end
    end
    else
    begin
      vga_data <= lastvga_data;
    end
  end

endmodule





