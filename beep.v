`timescale 1ns / 1ps
module beep(input wire clk,
              input wire [24:0] freq,
              input wire en,
              output reg buzzer);
  reg [24:0] cnt;
  always @ (posedge clk)
  begin
    if (en)
    begin
      cnt <= cnt + 1;
      if (cnt >= freq)
      begin
        cnt <= 0;
        buzzer = ~buzzer;
      end
    end
  end
endmodule
