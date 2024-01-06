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
	 input ps2_clk,
	 input ps2_data,
    output buzzer
  );

  reg [31:0]clkdiv;
  wire crash_signal;
  reg crash = 1'b0;
  always@(posedge clk)
  begin
    clkdiv <= clkdiv + 1'b1;
  end
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
	  
  wire KEY_LOW;
  wire KEY_JUMP;
  wire KEY_RESTART;
  
  Keyboard keyDevice(clk, ps2_clk, ps2_data, KEY_LOW, KEY_JUMP, KEY_RESTART);
 
  assign SEGLED_CLK = sout[3];
  assign SEGLED_DO = sout[2];
  assign SEGLED_PEN = sout[1];
  assign SEGLED_CLR = sout[0];
	
	
  wire [9:0] x;
  wire [8:0] y;
 
  wire [11:0] vga1_data;
  wire [11:0] vga_data;
  wire [11:0] vga2_data;
  wire [11:0] vga3_data;
  wire [11:0] vga4_data;
  wire [11:0] vga5_data;
  wire [9:0] col_addr;
  wire [8:0] row_addr;

  wire jump;
  wire jump_start;
  wire jump_all;
  wire show;
  wire [20:0]speed;
  assign reset1 = show||KEY_RESTART;
  assign jump_all = jump||jump_start;
  vgac v0 (
         .vga_clk(clkdiv[1]), .clrn(SW_OK[0]), .d_in(vga_data), .row_addr(row_addr), .col_addr(col_addr), .r(r), .g(g), .b(b), .hs(hs), .vs(vs)
       );
  Load_Gen(clk,clkdiv[17],KEY_JUMP,jump);
  speedup speedup(clk,reset1,speed);
  ground gnd(clk,~show,12'hfff,KEY_RESTART,row_addr,col_addr,speed,vga1_data);
  cloud cld(clk,~show,vga1_data,KEY_RESTART,row_addr,col_addr,speed,vga2_data);
  dinosaur dino(clk,clkdiv,1'b1,KEY_LOW,jump_all,vga2_data,SW[1],row_addr,col_addr,vga3_data,x,y);
  bird_cactus bc(clk,clkdiv,1'b1,vga3_data,reset1,row_addr,col_addr,speed,vga4_data,crash_signal);
  gameover gameover(clk,clkdiv,show,vga4_data,row_addr,col_addr,vga5_data);
  night night(clk,show,vga5_data,vga_data);
  ctrl ctrl(clk,KEY_RESTART,crash_signal,show,jump_start);
  grade grade(clk,show,segTestData);

  beep beepDevice(clk, 25'd227272, KEY_JUMP, buzzer);
  
  wire [15:0] ledData;
  assign ledData = SW_OK;
  ShiftReg #(.WIDTH(16)) ledDevice (.clk(clkdiv[3]), .pdata(~ledData), .sout({LED_CLK,LED_DO,LED_PEN,LED_CLR}));
endmodule
