/* Generated by Yosys 0.12 (git sha1 UNKNOWN, gcc 11.1.0 -march=x86-64 -mtune=generic -O2 -fno-plt -fPIC -Os) */

module s3fdp(clk, rst, S3_x, S3_y, FTZ, EOB, A, EOB_Q, isNaN);
  reg _00_;
  wire _01_;
  wire _02_;
  wire [11:0] _03_;
  wire [4:0] _04_;
  wire _05_;
  wire [11:0] _06_;
  wire [11:0] _07_;
  wire [4:0] _08_;
  wire [42:0] _09_;
  wire _10_;
  reg _11_;
  wire _12_;
  wire _13_;
  wire _14_;
  wire _15_;
  wire [31:0] _16_;
  wire _17_;
  wire _18_;
  wire _19_;
  wire _20_;
  wire [32:0] _21_;
  reg _22_;
  wire [32:0] _23_;
  wire [32:0] _24_;
  reg _25_;
  reg _26_;
  reg _27_;
  reg _28_;
  reg _29_;
  reg [32:0] _30_;
  output [31:0] A;
  input EOB;
  output EOB_Q;
  input FTZ;
  input [11:0] S3_x;
  input [11:0] S3_y;
  wire [32:0] acc_0;
  wire [32:0] acc_0_d1;
  wire [32:0] acc_0_q;
  wire carry_0;
  wire carry_0_sync;
  input clk;
  wire eob_internal;
  wire eob_internal_d1;
  wire eob_internal_d2;
  wire eob_internal_delayed;
  wire [31:0] ext_summand1c;
  output isNaN;
  wire isnan_delayed;
  wire isnan_m;
  wire isnan_m_d1;
  wire isnan_m_sync;
  wire isnan_o;
  wire isnan_o_d1;
  wire isnan_x;
  wire isnan_y;
  wire not_ftz;
  wire not_ftz_d1;
  wire not_ftz_sync;
  input rst;
  wire [4:0] scale_product_twice_biased;
  wire [3:0] scale_x_biased;
  wire [3:0] scale_y_biased;
  wire [4:0] shift_value;
  wire [42:0] shifted_significand;
  wire sign_m;
  wire sign_m_d1;
  wire sign_x;
  wire sign_y;
  wire [11:0] significand_product;
  wire [11:0] significand_product_cpt1;
  wire [5:0] significand_x;
  wire [5:0] significand_y;
  wire [31:0] summand_0;
  wire [32:0] summand_and_carry_0;
  wire too_big;
  wire too_big_d1;
  wire too_big_sync;
  wire too_small;
  wire too_small_d1;
  always @(posedge clk)
    _00_ <= sign_m;
  always @(posedge clk)
    _11_ <= isnan_m;
  always @(posedge clk)
    _22_ <= too_small;
  always @(posedge clk)
    _25_ <= too_big;
  always @(posedge clk)
    _26_ <= not_ftz;
  always @(posedge clk)
    _27_ <= eob_internal;
  always @(posedge clk)
    _28_ <= eob_internal_d1;
  always @(posedge clk, posedge rst)
    if (rst) _29_ <= 1'h0;
    else _29_ <= isnan_o;
  always @(posedge clk, posedge rst)
    if (rst) _30_ <= 33'h000000000;
    else _30_ <= acc_0;
  assign _01_ = sign_x ^ sign_y;
  assign _02_ = isnan_x | isnan_y;
  assign _04_ = { 1'h0, scale_x_biased } + { 1'h0, scale_y_biased };
  assign _05_ = ~ sign_m;
  assign _06_ = _05_ ? significand_product : _07_;
  assign _07_ = ~ significand_product;
  assign _08_ = scale_product_twice_biased - 5'h1f;
  assign _10_ = shift_value[4] ? 1'h1 : 1'h0;
  assign _12_ = $signed({ 1'h0, shift_value }) > $signed(6'h18);
  assign _13_ = ~ too_small;
  assign _14_ = _12_ & _13_;
  assign _15_ = _14_ ? 1'h1 : 1'h0;
  assign _16_ = too_small_d1 ? 32'd0 : shifted_significand[42:11];
  assign _17_ = ~ FTZ;
  assign _18_ = too_big_sync | isnan_m_sync;
  assign _19_ = _18_ | isnan_delayed;
  assign _20_ = not_ftz_sync ? _19_ : 1'h0;
  assign _21_ = { 1'h0, summand_0 } + { 32'h00000000, carry_0 };
  assign _23_ = { 1'h0, acc_0_q[31:0] } + summand_and_carry_0;
  assign _24_ = not_ftz_sync ? _23_ : summand_and_carry_0;
  IntMultiplier_F400_uid31 significand_product_inst (
    .R(_03_),
    .X(significand_x),
    .Y(significand_y),
    .clk(clk)
  );
  LeftShifter12_by_max_31_F400_uid38 significand_product_shifter_inst (
    .R(_09_),
    .S(shift_value),
    .X(significand_product_cpt1),
    .clk(clk),
    .padBit(sign_m)
  );
  assign sign_x = S3_x[10];
  assign sign_y = S3_y[10];
  assign sign_m = _01_;
  assign sign_m_d1 = _00_;
  assign isnan_x = S3_x[11];
  assign isnan_y = S3_y[11];
  assign isnan_m = _02_;
  assign isnan_m_d1 = _11_;
  assign significand_x = S3_x[9:4];
  assign significand_y = S3_y[9:4];
  assign significand_product = _03_;
  assign scale_x_biased = S3_x[3:0];
  assign scale_y_biased = S3_y[3:0];
  assign scale_product_twice_biased = _04_;
  assign significand_product_cpt1 = _06_;
  assign shift_value = _08_;
  assign shifted_significand = _09_;
  assign too_small = _10_;
  assign too_small_d1 = _22_;
  assign too_big = _15_;
  assign too_big_d1 = _25_;
  assign ext_summand1c = _16_;
  assign not_ftz = _17_;
  assign not_ftz_d1 = _26_;
  assign eob_internal = EOB;
  assign eob_internal_d1 = _27_;
  assign eob_internal_d2 = _28_;
  assign not_ftz_sync = not_ftz_d1;
  assign carry_0_sync = sign_m_d1;
  assign eob_internal_delayed = eob_internal_d2;
  assign isnan_m_sync = isnan_m_d1;
  assign too_big_sync = too_big_d1;
  assign isnan_o = _20_;
  assign isnan_o_d1 = _29_;
  assign isnan_delayed = isnan_o_d1;
  assign carry_0 = carry_0_sync;
  assign summand_0 = ext_summand1c;
  assign summand_and_carry_0 = _21_;
  assign acc_0 = _24_;
  assign acc_0_d1 = _30_;
  assign acc_0_q = acc_0_d1;
  assign A = acc_0_q[31:0];
  assign EOB_Q = eob_internal_delayed;
  assign isNaN = isnan_delayed;
endmodule
