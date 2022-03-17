`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
//
// Engineer: LEDOUX Louis
//
// Create Date: 17/03/2022
// Description: 
// Orthogonal Systolic Array of 3x3 Processing Elements (PEs)
// Performs A.A^T
// With posit<8,0> arithmetic and exact accumulators, in this case "Quires"
//
//////////////////////////////////////////////////////////////////////////////////


module teras #
(
    parameter integer DATA_WIDTH = 32 // this is the wishbone data width
)
(
    // System signals
    input  wire clk,
    input  wire rst_n,

    // SLAVE SIDE

    // control signals
    output wire rtr_o,
    input  wire rts_i,
    // data in
    input wire [DATA_WIDTH-1:0] data_i,

    // MASTER SIDE

    // control signals
    input  wire rtr_i,
    output wire rts_o,
    // data out
    output wire [DATA_WIDTH-1:0] data_o
);

// localparams
localparam integer ARITH_IN_WIDTH = 8;
localparam integer ARITH_OUT_WIDTH = 8;
localparam integer N = 3;  // rows of the array
localparam integer M = 3;  // columns of the array
// this number exists only after a flopoco run
localparam integer S3FDP_PP_DEPTH = 2;
localparam integer L2A_PP_DEPTH = 7;
localparam integer FIFO_DEPTH = 16;
localparam integer OUT_WIDTH = M*ARITH_OUT_WIDTH;
localparam integer FIFO_WIDTH = OUT_WIDTH;

// signals

// SA
wire [DATA_WIDTH-1:0] sa_data_i;
wire [OUT_WIDTH-1:0] sa_data_o;
wire sa_eob;
wire sa_eob_q;
wire sa_valid_o;
wire sa_sob;

// FIFO
wire [OUT_WIDTH-1:0] fifo_data_o;
wire fifo_valid_o;

//    _____ __
//   / ___// /___ __   _____
//   \__ \/ / __ `/ | / / _ \
//  ___/ / / /_/ /| |/ /  __/
// /____/_/\__,_/ |___/\___/
assign rtr_o = rtr_i;
assign sa_data_i = (rts_i & rtr_o) ? data_i : {DATA_WIDTH{1'b0}};
assign sa_eob = sa_data_i[DATA_WIDTH-1];
assign sa_sob = sa_data_i[DATA_WIDTH-2];

//    _____ ___
//   / ___//   |
//   \__ \/ /| |
//  ___/ / ___ |
// /____/_/  |_|
SystolicArray sa_inst (

    // System
    .clk     ( clk                               ),
    .rst     ( ~rst_n                            ),

    // IOs
    .rowsA   ( sa_data_i[(N*ARITH_IN_WIDTH)-1:0] ), 
    .colsB   ( sa_data_i[(N*ARITH_IN_WIDTH)-1:0] ),
    .SOB     ( sa_sob                            ),
    .EOB     ( sa_eob                            ),
    .colsC   ( sa_data_o                         ),
    .EOB_Q_o ( sa_eob_q                          )

);

// valid_o from systolic array logic
// we will create a shift register of size N+2+PP_DEPTH(S3FDP)-1+PP_DEPTH(L2A)
// we connect the eob_q of PE(N-1,M-1) as the input bit
// the OR reduction from the N MSB bits are the valid signal
localparam integer size = N+2+S3FDP_PP_DEPTH+L2A_PP_DEPTH-1;
reg [size-1:0] shift_register;
always @(posedge clk or negedge rst_n) begin
	if ( ~rst_n ) begin
		shift_register <= 0;
	end
	else begin
		shift_register <= {shift_register[size-2:0],sa_eob_q};
	end
end
assign sa_valid_o = |shift_register[(size-2) -: N];
//     ____________________
//    / ____/  _/ ____/ __ \
//   / /_   / // /_  / / / /
//  / __/ _/ // __/ / /_/ /
// /_/   /___/_/    \____/
// this fifo acts as backpressure FIFO that accepts data from the systolic array
// in case the host ready is de-acked. Should never be full, the depth is ~the execution time
// of the SA
fifo #
(
    .C_WIDTH ( FIFO_WIDTH ),
    .C_DEPTH ( FIFO_DEPTH ),
    .C_DELAY ( 2 )
) fifo_inst (
     .CLK      ( clk                  ), // Clock
     .RST      ( ~rst_n               ), // Sync reset, active high

     .WR_DATA  ( sa_data_o            ), // Write data input
     .WR_VALID ( sa_valid_o           ), // Write enable, high active
     .WR_READY ( ), // ~Full condition

     .RD_DATA  ( fifo_data_o          ), // Read data output
     .RD_READY ( rtr_i & fifo_valid_o ), // Read enable, high active
     .RD_VALID ( fifo_valid_o         )  // ~Empty condition
);

//     __  ___           __
//    /  |/  /___ ______/ /____  _____
//   / /|_/ / __ `/ ___/ __/ _ \/ ___/
//  / /  / / /_/ (__  ) /_/  __/ /
// /_/  /_/\__,_/____/\__/\___/_/
assign rts_o  = fifo_valid_o;
assign data_o = {{DATA_WIDTH-OUT_WIDTH{1'b0}},fifo_data_o};

endmodule
`default_nettype wire
