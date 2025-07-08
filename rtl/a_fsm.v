// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: a_fsm.v
//	* Description	: 
// ==================================================

module a_fsm
(	
	output reg			o_mode,
	output reg	[2:0]	o_dut_addr,
	output reg	[9:0]	o_ref_dly_sel,
	output reg	[8:0]	o_dat_dly_sel,
	output reg	[8:0]	o_clk_dly_sel,
	output reg	[1:0]	o_mux_sel,
	input		[1:0]	i_mode,
	input				i_mux_out,
	input				i_start,
	input				i_clk,
	input				i_rstn
);

	
// --------------------------------------------------
	localparam	M_SE_R		= 2'd0;
	localparam	M_SE_F		= 2'd1;
	localparam	M_HD_R		= 2'd2;
	localparam	M_HD_F		= 2'd3;

	localparam	S_IDLE		= 3'd0;
	localparam	S_FIX_TCLK	= 3'd1;
	localparam	S_MIN_TQ	= 3'd2;
	localparam	S_MIN_TD	= 3'd3;
	localparam	S_TQ_SAMPLE	= 3'd4;
	localparam	S_TD_SAMPLE	= 3'd5;
	localparam	S_DONE		= 3'd6;

	localparam	E_INIT		= 2'd0;
	localparam	E_UPDATE	= 2'd1;
	localparam	E_DONE		= 2'd2;

	reg			[2:0]	p_state ;
	reg			[2:0]	c_state ;
	reg			[2:0]	n_state ;
	reg			[2:0]	c_exec  ;
	reg			[2:0]	n_exec  ;

	// State Register
	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			p_state	<= S_IDLE;
			c_state	<= S_IDLE;
		end else begin
			p_state	<= c_state;
			c_state	<= n_state;
		end
	end

	// State Register
	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			c_exec	<= E_INIT;
		end else begin
			c_exec	<= n_exec;
		end
	end

	reg		[5:0]	cnt_ref;
	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			cnt_ref <= 0;
		end else begin
			case(c_exec)
				E_INIT   : cnt_ref <= 0;
				E_UPDATE : cnt_ref	<= cnt_ref + 1;
				E_DONE   : cnt_ref	<= cnt_ref + 1;
			endcase
		end
	end

	// Next State Logic
	always @(*) begin
		case(c_state)
			S_IDLE      : n_state = i_start            ? S_FIX_TCLK  : S_IDLE;
			S_FIX_TCLK  : n_state = (n_exec == E_DONE) ? S_MIN_TQ    : S_FIX_TCLK;
			S_MIN_TQ    : n_state = (n_exec == E_DONE) ? S_MIN_TD    : S_MIN_TQ;
			S_MIN_TD    : n_state = (n_exec == E_DONE) ? S_TD_SAMPLE : S_MIN_TD;
			S_TD_SAMPLE : n_state = (n_exec == E_DONE) ? S_TQ_SAMPLE : S_TD_SAMPLE;
			S_TQ_SAMPLE : n_state = (n_exec == E_DONE) ? S_DONE      : S_TQ_SAMPLE;
			S_DONE      : n_state = S_IDLE;
		endcase
	end

	always @(*) begin
		case(c_exec)
			E_INIT   : n_exec = (p_state != c_state) ? E_UPDATE : E_INIT;
			E_UPDATE : n_exec = (cnt_exec == 15)     ? E_DONE   : E_UPDATE;
			E_DONE   : n_exec = E_INIT;
		endcase
	end

	

	// Output Logic
	always @(*) begin
		case(c_state)
			S_FIX_TCLK  : begin
			end
			S_MIN_TQ    : 
			S_MIN_TD    : 
			S_TD_SAMPLE : 
			S_TQ_SAMPLE : 
			S_DONE      : 
		endcase
	end



endmodule
