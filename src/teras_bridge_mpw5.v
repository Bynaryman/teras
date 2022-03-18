`default_nettype none
/*
 *
 *
 */

module teras_bridge_mpw5 (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] matrix_c_out;

    wire valid;
    wire matrix_c_valid;

    // WB
    assign valid = wbs_cyc_i && wbs_stb_i; 

    // IO
    assign io_out[31:8] = matrix_c_out[23:0];
    assign io_out[32]   = matrix_c_valid;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = {{(127-33){1'b0}}, matrix_c_valid, matrix_c_out};
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

    teras teras_inst (
        // System signals
        .clk    ( clk             ),
        .rst_n  ( ~rst            ),

        // SLAVE SIDE

        // control signals
        .rtr_o  ( wbs_ack_o      ),
        .rts_i  ( valid          ),
        // data in
        .data_i ( wbs_dat_i      ),

        // MASTER SIDE

        // control signals
        .rtr_i  ( 1'b1           ),
        .rts_o  ( matrix_c_valid ),
        // data out
        .data_o ( matrix_c_out   )
    );

endmodule
`default_nettype wire
