// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: a_fsm.v
//	* Description	: 
// ==================================================

module a_fsm
(	
	output 		[2:0]	o_state,
	output 		[10:0]	o_dly_ref,
	output reg	[8:0]	o_dly_dat,
	output				o_edge_d,
	output				o_edge_c,
	output 				o_edge_m,
	output reg	[1:0]	o_sigs_sel,
	input		[1:0]	i_mode,
	input		[4:0]	i_dut_addr,
	input		[3:0]	i_reg_addr,
	input				i_osc_en,
	input				i_start,
	input				i_cff_out,
	input				i_clk,
	input				i_rstn
);

// --------------------------------------------------
// Mode
// --------------------------------------------------
	localparam	REF_DLY_BIT	= 11;
	localparam	DAT_DLY_BIT	= 9;
	localparam	REF_DLY_MAX	= 2**REF_DLY_BIT-1;
	localparam	DAT_DLY_MAX	= 2**DAT_DLY_BIT-1;
	localparam	REF_CYCLES	= REF_DLY_BIT+2;
	localparam	DAT_CYCLES	= DAT_DLY_BIT+2;

	localparam	NUM_SAMPLE	= 4;

	localparam	M_SU_R		= 2'd0;
	localparam	M_SU_F		= 2'd1;
	localparam	M_HD_R		= 2'd2;
	localparam	M_HD_F		= 2'd3;

	localparam	S_IDLE		= 3'd0;
	localparam	S_FIX_TCLK	= 3'd1;
	localparam	S_MIN_TQ_D	= 3'd2;
	localparam	S_MIN_TQ_Q	= 3'd3;
	localparam	S_MIN_TD_F	= 3'd4;
	localparam	S_SAMPLE_D	= 3'd5;
	localparam	S_SAMPLE_Q	= 3'd6;
	localparam	S_DONE		= 3'd7;
	reg			[10:0]	dly_ref;

	reg			[2:0]	c_state ;
	reg			[2:0]	n_state ;

	assign		o_state	= c_state;

	// State Register
	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			c_state	<= S_IDLE;
		end else begin
			c_state	<= n_state;
		end
	end

	reg		[4:0]	cnt_state;
	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			cnt_state	<= 0;
		end else begin
			if (c_state == n_state) begin
				cnt_state	<= cnt_state + 1;
			end else begin
				cnt_state	<= 0;
			end
		end
	end

	reg		[2:0]	cnt_smpls;
	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			cnt_smpls	<= 0;
		end else begin
			if (c_state == S_SAMPLE_Q && n_state == S_SAMPLE_D) begin
				cnt_smpls	<= cnt_smpls + 1;
			end else if (c_state == S_DONE) begin
				cnt_smpls	<= 0;
			end else begin
				cnt_smpls	<= cnt_smpls;
			end
		end
	end

	always @(*) begin
		case(c_state)
			S_IDLE      : n_state = i_start                                    ? S_FIX_TCLK : c_state ;
			S_FIX_TCLK	: n_state = (cnt_state >= REF_CYCLES  -1) && i_cff_out ? S_MIN_TQ_D : c_state ;
			S_MIN_TQ_D	: n_state = (cnt_state >= REF_CYCLES  -1) && i_cff_out ? S_MIN_TQ_Q : c_state ;
			S_MIN_TQ_Q	: n_state = (cnt_state >= 2*REF_CYCLES-1) && i_cff_out ? S_MIN_TD_F : c_state ;
			S_MIN_TD_F	: n_state = (cnt_state >= DAT_CYCLES  -1) && i_cff_out ? S_SAMPLE_D : c_state ;
			S_SAMPLE_D  : n_state = (cnt_state >= REF_CYCLES  -1) && i_cff_out ? S_SAMPLE_Q : c_state ;
			S_SAMPLE_Q  : n_state = (cnt_state >= 2*REF_CYCLES-1) && i_cff_out ? ((cnt_smpls == NUM_SAMPLE - 1) ? S_DONE  : S_SAMPLE_D) : c_state;
			S_DONE		: n_state = S_IDLE;
		endcase
	end

	// Output Logic
	always @(posedge i_clk or negedge i_rstn) begin
		if (!i_rstn) begin
			dly_ref	<= REF_DLY_MAX;
		end else begin
			case (c_state)
				S_IDLE		,
				S_MIN_TD_F	,
				S_DONE		: dly_ref	<= REF_DLY_MAX;
				S_FIX_TCLK	, 
				S_MIN_TQ_D	, 
				S_MIN_TD_F	, 
				S_SAMPLE_D  : begin
					if (n_state != c_state) begin
						dly_ref	<= REF_DLY_MAX;
					end else if (cnt_state <= REF_CYCLES - 3) begin
						dly_ref	<= i_cff_out ? dly_ref - 2**(REF_DLY_BIT - 1 - cnt_state) :
												   dly_ref + 2**(REF_DLY_BIT - 1 - cnt_state) ;
					end else begin
						dly_ref	<= i_cff_out ? dly_ref - 1 : dly_ref + 1;
					end
				end
				default		: begin
					if (n_state != c_state) begin
						dly_ref	<= REF_DLY_MAX;
					end else begin
						if (cnt_state[0]) begin
							if (cnt_state <= 2*(REF_CYCLES - 3)) begin
								dly_ref	<= i_cff_out ? dly_ref - 2**(REF_DLY_BIT - 1 - cnt_state[4:1]) :
														   dly_ref + 2**(REF_DLY_BIT - 1 - cnt_state[4:1]) ;
							end else begin
								dly_ref	<= i_cff_out ? dly_ref - 1 : dly_ref + 1;
							end
						end else begin
							dly_ref	<= dly_ref;
						end
					end
				end
			endcase
		end
	end

	reg		[DAT_DLY_BIT-1:0]	dly_dat;
	always @(posedge i_clk or negedge i_rstn) begin
		if (!i_rstn) begin
			dly_dat	<= 0;
		end else begin
			if (c_state == S_MIN_TD_F) begin
				dly_dat	<= o_dly_dat;
			end else begin
				dly_dat	<= dly_dat;
			end
		end
	end

	always @(posedge i_clk or negedge i_rstn) begin
		if (!i_rstn) begin
			o_dly_dat	<= 0;
		end else begin
			case (n_state)
				S_MIN_TQ_D	: begin
					case(i_mode)
						M_SU_R	,
						M_SU_F	: o_dly_dat <= 0;
						M_HD_R	,
						M_HD_F	: o_dly_dat <= DAT_DLY_MAX;
					endcase
				end
				S_MIN_TQ_Q	: begin
					case(i_mode)
						M_SU_R	,
						M_SU_F	: o_dly_dat <= (c_state == S_MIN_TQ_D) ? DAT_DLY_MAX : cnt_state[0] ? DAT_DLY_MAX : 0;
						M_HD_R	,
						M_HD_F	: o_dly_dat <= (c_state == S_MIN_TQ_D) ? 0 : cnt_state[0] ? 0 : DAT_DLY_MAX;
					endcase
				end
				S_MIN_TD_F	: begin
					case(i_mode)
						M_SU_R	,
						M_SU_F	: begin
							if (c_state == S_MIN_TQ_Q) begin
								o_dly_dat <= 0;
							end else begin
								if (cnt_state <= DAT_CYCLES - 3) begin
									o_dly_dat <= i_cff_out ? o_dly_dat + 2**(DAT_DLY_BIT - 1 - cnt_state) :
															 o_dly_dat - 2**(DAT_DLY_BIT - 1 - cnt_state) ;
								end else begin
									o_dly_dat <= i_cff_out ? o_dly_dat + 1 : o_dly_dat - 1;
								end
							end
						end
						M_HD_R	,
						M_HD_F	: begin
							if (c_state == S_MIN_TQ_Q) begin
								o_dly_dat <= DAT_DLY_MAX;
							end else begin
								if (cnt_state <= DAT_CYCLES - 3) begin
									o_dly_dat <= i_cff_out ? o_dly_dat - 2**(DAT_DLY_BIT - 1 - cnt_state) :
														     o_dly_dat + 2**(DAT_DLY_BIT - 1 - cnt_state) ;
								end else begin
									o_dly_dat <= i_cff_out ? o_dly_dat - 1 : o_dly_dat + 1;
								end
							end
						end
					endcase
				end
				//S_SAMPLE_D	: o_dly_dat <= i_mode[1] ? dly_dat + 2*cnt_smpls : dly_dat - 2*cnt_smpls;
				S_SAMPLE_D	: o_dly_dat <= cnt_smpls == 0 ? o_dly_dat : i_mode[1] ? dly_dat + 2*cnt_smpls : dly_dat - 2*cnt_smpls;
				S_SAMPLE_Q	: begin
					case(i_mode)
						M_SU_R	,
						M_SU_F	: o_dly_dat <= cnt_state[0] ? DAT_DLY_MAX : i_mode[1] ? dly_dat + 2*cnt_smpls : dly_dat - 2*cnt_smpls;
						M_HD_R	,
						M_HD_F	: o_dly_dat <= cnt_state[0] ? 0           : i_mode[1] ? dly_dat + 2*cnt_smpls : dly_dat - 2*cnt_smpls;
					endcase
				end
				default		: o_dly_dat	<= 0;
			endcase
		end
	end

// --------------------------------------------------
// Register
// --------------------------------------------------
	reg			[10:0]	reg_dly_ref[0:10];

	always @(posedge i_clk or negedge i_rstn) begin
		if (!i_rstn) begin
			reg_dly_ref[ 0]	<= 0;
			reg_dly_ref[ 1]	<= 0;
			reg_dly_ref[ 2]	<= 0;
			reg_dly_ref[ 3]	<= 0;
			reg_dly_ref[ 4]	<= 0;
			reg_dly_ref[ 5]	<= 0;
			reg_dly_ref[ 6]	<= 0;
			reg_dly_ref[ 7]	<= 0;
			reg_dly_ref[ 8]	<= 0;
			reg_dly_ref[ 9]	<= 0;
			reg_dly_ref[10]	<= 0;
		end else begin
			case(c_state)
				S_FIX_TCLK	:	reg_dly_ref[ 0]	<= dly_ref;
				S_MIN_TQ_D	:	reg_dly_ref[ 1]	<= dly_ref;
				S_MIN_TQ_Q	:	reg_dly_ref[ 2]	<= dly_ref;
				S_SAMPLE_D	:	begin
					case(cnt_smpls)
						0	:	reg_dly_ref[ 3]	<= dly_ref;
						1	:	reg_dly_ref[ 5]	<= dly_ref;
						2	:	reg_dly_ref[ 7]	<= dly_ref;
						3	:	reg_dly_ref[ 9]	<= dly_ref;
					endcase
				end
				S_SAMPLE_Q	:	begin
					case(cnt_smpls)
						0	:	reg_dly_ref[ 4]	<= dly_ref;
						1	:	reg_dly_ref[ 6]	<= dly_ref;
						2	:	reg_dly_ref[ 8]	<= dly_ref;
						3	:	reg_dly_ref[10]	<= dly_ref;
					endcase
				end
			endcase
		end
	end

	assign	o_dly_ref	= i_osc_en ? reg_dly_ref[i_reg_addr] : dly_ref;

// --------------------------------------------------
// Control Signals
// --------------------------------------------------
	always @(*) begin
		case(c_state)
			S_IDLE      : o_sigs_sel = 0;
			S_FIX_TCLK	: o_sigs_sel = 1;
			S_MIN_TQ_D	: o_sigs_sel = 0;
			S_MIN_TQ_Q	: o_sigs_sel = i_dut_addr[0] ? 3:2;
			S_MIN_TD_F	: o_sigs_sel = i_dut_addr[0] ? 3:2;
			S_SAMPLE_D  : o_sigs_sel = 0;
			S_SAMPLE_Q  : o_sigs_sel = i_dut_addr[0] ? 3:2;
			S_DONE		: o_sigs_sel = 0;
		endcase
	end

	assign		o_edge_d	= i_mode[1] ^ i_mode[0];
	assign		o_edge_c	= 0;
	assign		o_edge_m	= (o_sigs_sel == 0) ? i_mode[1] ^ i_mode[0] :
							  (o_sigs_sel == 1) ? 0	: i_mode[0] ;

endmodule
