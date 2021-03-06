/* Generated by Yosys 0.12 (git sha1 UNKNOWN, gcc 11.1.0 -march=x86-64 -mtune=generic -O2 -fno-plt -fPIC -Os) */

module IntMultiplier_F400_uid31(clk, X, Y, R);
  wire [11:0] _0_;
  output [11:0] R;
  input [5:0] X;
  input [5:0] Y;
  wire bh33_w0_0;
  wire bh33_w10_0;
  wire bh33_w11_0;
  wire bh33_w1_0;
  wire bh33_w2_0;
  wire bh33_w3_0;
  wire bh33_w4_0;
  wire bh33_w5_0;
  wire bh33_w6_0;
  wire bh33_w7_0;
  wire bh33_w8_0;
  wire bh33_w9_0;
  wire [11:0] bitheapresult_bh33;
  input clk;
  wire [11:0] tile_0_filtered_output;
  wire [11:0] tile_0_output;
  wire [5:0] tile_0_x;
  wire [5:0] tile_0_y;
  wire [11:0] tmp_bitheapresult_bh33_11;
  DSPBlock_6x6_F400_uid35 tile_0_mult (
    .R(_0_),
    .X(tile_0_x),
    .Y(tile_0_y),
    .clk(clk)
  );
  assign tile_0_x = X;
  assign tile_0_y = Y;
  assign tile_0_output = _0_;
  assign tile_0_filtered_output = tile_0_output;
  assign bh33_w0_0 = tile_0_filtered_output[0];
  assign bh33_w1_0 = tile_0_filtered_output[1];
  assign bh33_w2_0 = tile_0_filtered_output[2];
  assign bh33_w3_0 = tile_0_filtered_output[3];
  assign bh33_w4_0 = tile_0_filtered_output[4];
  assign bh33_w5_0 = tile_0_filtered_output[5];
  assign bh33_w6_0 = tile_0_filtered_output[6];
  assign bh33_w7_0 = tile_0_filtered_output[7];
  assign bh33_w8_0 = tile_0_filtered_output[8];
  assign bh33_w9_0 = tile_0_filtered_output[9];
  assign bh33_w10_0 = tile_0_filtered_output[10];
  assign bh33_w11_0 = tile_0_filtered_output[11];
  assign tmp_bitheapresult_bh33_11 = { bh33_w11_0, bh33_w10_0, bh33_w9_0, bh33_w8_0, bh33_w7_0, bh33_w6_0, bh33_w5_0, bh33_w4_0, bh33_w3_0, bh33_w2_0, bh33_w1_0, bh33_w0_0 };
  assign bitheapresult_bh33 = tmp_bitheapresult_bh33_11;
  assign R = bitheapresult_bh33;
endmodule
