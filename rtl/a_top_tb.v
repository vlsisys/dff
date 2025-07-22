// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: a_top_tb.v
//	* Description	: 
// ==================================================
// --------------------------------------------------
//	Define Global Variables
// --------------------------------------------------
`define	CLKFREQ		5		// Clock Freq. (Unit: MHz)
`define	SIMCYCLE	`NVEC	// Sim. Cycles
`define BW_DATA		32		// Bitwidth of ~~
`define BW_ADDR		5		// Bitwidth of ~~
`define BW_CTRL		4		// Bitwidth of ~~
`define NVEC		100		// # of Test Vector

// --------------------------------------------------
//	Includes
// --------------------------------------------------
`include	"configs.v"
`include	"u_dec3to8.v"
`include	"u_dff.v"
`include	"u_dly_coarse16.v"
`include	"u_dly_coarse8.v"
`include	"u_dly_fine.v"
`include	"u_dut.v"
`include	"u_thermometer64.v"
`include	"u_tile.v"
`include	"c_dly_fine64.v"
`include	"b_dly_f64c16.v"
`include	"b_dly_f64c8.v"
`include	"a_delay_clk.v"
`include	"a_delay_dat.v"
`include	"a_delay_ref.v"
`include	"a_fsm.v"
`include	"a_tile_array.v"
`include	"a_top.v"

module a_top_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	output 			o_osc;
	output 			o_cff;
	reg		[1:0]	i_mode;
	reg		[4:0]	i_addr;
	reg				i_osc_en;
	reg				i_start;
	reg				i_clk;
	reg				i_rstn;

	a_top
	dut(
		.o_osc				(o_osc				),
		.o_cff				(o_cff				),
		.i_mode				(i_mode				),
		.i_addr				(i_addr				),
		.i_osc_en			(i_osc_en			),
		.i_start			(i_start			),
		.i_clk				(i_clk				),
		.i_rstn				(i_rstn				)
	);

// --------------------------------------------------
//	Clock
// --------------------------------------------------
	always	#(500000/`CLKFREQ)		i_clk = ~i_clk;

// --------------------------------------------------
//	Tasks
// --------------------------------------------------
	reg		[4*32-1:0]	taskState;
	integer				err	= 0;

	task init;
		begin
			taskState		= "Init";
			i_mode				= 0;
			i_addr				= 0;
			i_osc_en			= 0;
			i_start				= 0;
			i_clk				= 0;
			i_rstn				= 0;
		end
	endtask

	task resetNCycle;
		input	[9:0]	i;
		begin
			taskState		= "Reset";
			i_rstn	= 1'b0;
			#(i*1000000/`CLKFREQ);
			i_rstn	= 1'b1;
		end
	endtask

// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		resetNCycle(4);
		i_start	= 1;
		#(1000000/`CLKFREQ);
		i_start	= 0;
		#(250*1000000/`CLKFREQ);
		$finish;
	end

// --------------------------------------------------
//	Dump VCD
// --------------------------------------------------
	reg	[8*32-1:0]	vcd_file;
	initial begin
		if ($value$plusargs("vcd_file=%s", vcd_file)) begin
			$dumpfile(vcd_file);
			$dumpvars;
		end else begin
			$dumpfile("a_top_tb.vcd");
			$dumpvars;
		end
	end

// --------------------------------------------------
//	DEBUG
// --------------------------------------------------
	localparam	S_IDLE		= 4'd 0;
	localparam	S_FIX_TCLK	= 4'd 1;
	localparam	S_MIN_TQ_D	= 4'd 2;
	localparam	S_MIN_TQ_Q	= 4'd 3;
	localparam	S_MIN_TD_D0	= 4'd 4;
	localparam	S_MIN_TD_D1	= 4'd 5;
	localparam	S_MIN_TD_Q	= 4'd 6;
	localparam	S_SAMPLE_D	= 4'd 7;
	localparam	S_SAMPLE_Q	= 4'd 8;
	localparam	S_DONE		= 4'd15;

	reg			[127:0]			ASCII_C_STATE;
	always @(*) begin
		case (dut.u_a_fsm.c_state)
			S_IDLE      : ASCII_C_STATE = "IDLE     ";
			S_FIX_TCLK	: ASCII_C_STATE = "FIX_TCLK	";
			S_MIN_TQ_D	: ASCII_C_STATE = "MIN_TQ_D	";
			S_MIN_TQ_Q	: ASCII_C_STATE = "MIN_TQ_Q	";
			S_MIN_TD_D0 : ASCII_C_STATE = "MIN_TD_D0";
			S_MIN_TD_D1 : ASCII_C_STATE = "MIN_TD_D1";
			S_MIN_TD_Q  : ASCII_C_STATE = "MIN_TD_Q ";
			S_SAMPLE_D  : ASCII_C_STATE = "SAMPLE_D ";
			S_SAMPLE_Q  : ASCII_C_STATE = "SAMPLE_Q ";
			S_DONE		: ASCII_C_STATE = "DONE		";
		endcase
	end

endmodule
