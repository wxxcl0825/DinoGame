module Keyboard (
    input wire clk,
    input wire ps2_clk,
    input wire ps2_data,
    output wire KEY_LOW,
    output wire  KEY_JUMP,
    output wire KEY_RESTART
  );
  wire [9:0] data_out;
  wire [7:0] key;
  reg [2:0] state;
  PS2 m0(.clk(clk), .rst(1'b0), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .data_out(data_out));
  assign key = data_out[7:0];

  always @ (posedge clk)
  begin
    if (data_out[8] == 1'b1)
      state <= 0;
    else
    begin
      case(key)
        8'h72:
          state <= 3'b100;
        8'h29:
          state <= 3'b010;
        8'h2D:
          state <= 3'b001;
        default:
          state <= 3'b000;
      endcase
    end
  end

  assign KEY_LOW = state[2];
  assign KEY_JUMP = state[1];
  assign KEY_RESTART = state[0];

endmodule
