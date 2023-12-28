`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2016/10/17 12:25:41
// Design Name:
// Module Name: Top
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input clk,
    input rstn,
    input [15:0]SW,
    output hs,
    output vs,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b,
    output SEGLED_CLK,
    output SEGLED_CLR,
    output SEGLED_DO,
    output SEGLED_PEN,
    output LED_CLK,
    output LED_CLR,
    output LED_DO,
    output LED_PEN,
    inout [4:0]BTN_X,
    inout [3:0]BTN_Y,
    output buzzer
  );

  reg [31:0]clkdiv;
  always@(posedge clk)
  begin
    clkdiv <= clkdiv + 1'b1;
  end
  assign buzzer = 1'b1;
  wire [15:0] SW_OK;
  AntiJitter #(4) a0[15:0](.clk(clkdiv[15]), .I(SW), .O(SW_OK));

  wire [4:0] keyCode;
  wire keyReady;
  Keypad k0 (.clk(clkdiv[15]), .keyX(BTN_Y), .keyY(BTN_X), .keyCode(keyCode), .ready(keyReady));

  wire [31:0] segTestData;
  wire [3:0]sout;
  Seg7Device segDevice(.clkIO(clkdiv[3]), .clkScan(clkdiv[15:14]), .clkBlink(clkdiv[25]),
                       .data(segTestData), .point(8'h0), .LES(8'h0),
                       .sout(sout));
  assign SEGLED_CLK = sout[3];
  assign SEGLED_DO = sout[2];
  assign SEGLED_PEN = sout[1];
  assign SEGLED_CLR = sout[0];


  wire [9:0] x;
  wire [8:0] y;

  wire [11:0] vga_data;
  wire [9:0] col_addr;
  wire [8:0] row_addr;
  wire [19:0] x_sqr, y_sqr, r_sqr;

  vgac v0 (
         .vga_clk(clkdiv[1]), .clrn(SW_OK[0]), .d_in(vga_data), .row_addr(row_addr), .col_addr(col_addr), .r(r), .g(g), .b(b), .hs(hs), .vs(vs)
       );
  dinosaur dino(clk,1'b1,12'hfff,SW[1],row_addr,col_addr,vga_data,x,y);

  assign segTestData = {1'b0,x,y,vga_data};
  wire [15:0] ledData;
  assign ledData = SW_OK;
  ShiftReg #(.WIDTH(16)) ledDevice (.clk(clkdiv[3]), .pdata(~ledData), .sout({LED_CLK,LED_DO,LED_PEN,LED_CLR}));
endmodule
