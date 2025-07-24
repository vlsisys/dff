// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: a_fsm.v
//	* Description	: 
// ==================================================

module a_fsm
(	
	output reg	[10:0]	o_dly_ref,
	output reg	[8:0]	o_dly_dat,
	output				o_edge_d,
	output				o_edge_c,
	output				o_edge_m,
	output reg	[1:0]	o_sigs_sel,
	input		[1:0]	i_mode,
	input		[4:0]	i_addr,
	input				i_start,
	input				i_cff_out,
	input				i_clk,
	input				i_rstn
);

// --------------------------------------------------
// Mode
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

	localparam	S_IDLE		= 4'd 0;
	localparam	S_FIX_TCLK	= 4'd 1;
	localparam	S_MIN_TQ_D	= 4'd 2;
	localparam	S_MIN_TQ_Q	= 4'd 3;
	localparam	S_MIN_TD_F	= 4'd 4;
	localparam	S_MIN_TD_D	= 4'd 5;
	localparam	S_MIN_TD_Q	= 4'd 6;
	localparam	S_SAMPLE_D	= 4'd 7;
	localparam	S_SAMPLE_Q	= 4'd 8;
	localparam	S_DONE		= 4'd15;

	reg			[3:0]	p_state ;
	reg			[3:0]	c_state ;
	reg			[3:0]	n_state ;

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
			S_IDLE      : n_state = !i_start                      ? c_state : S_FIX_TCLK ;
			S_FIX_TCLK	: n_state = (cnt_state != REF_CYCLES  -1) ? c_state : S_MIN_TQ_D ;
			S_MIN_TQ_D	: n_state = (cnt_state != REF_CYCLES  -1) ? c_state : S_MIN_TQ_Q ;
			S_MIN_TQ_Q	: n_state = (cnt_state != 2*REF_CYCLES-1) ? c_state : S_MIN_TD_F;
			S_MIN_TD_F	: n_state = (cnt_state != DAT_CYCLES  -1) ? c_state : S_MIN_TD_D;
			S_MIN_TD_D	: n_state = (cnt_state != REF_CYCLES  -1) ? c_state : S_MIN_TD_Q ;
			S_MIN_TD_Q  : n_state = (cnt_state != 2*REF_CYCLES-1) ? c_state : S_SAMPLE_D ;
			S_SAMPLE_D  : n_state = (cnt_state != REF_CYCLES  -1) ? c_state : S_SAMPLE_Q ;
			S_SAMPLE_Q  : n_state = (cnt_state != 2*REF_CYCLES-1) ? c_state :
				                    (cnt_smpls == NUM_SAMPLE - 1) ? S_DONE  : S_SAMPLE_D ;
			S_DONE		: n_state = S_IDLE;
		endcase
	end

	// Output Logic
	always @(posedge i_clk or negedge i_rstn) begin
		if (!i_rstn) begin
			o_dly_ref	<= REF_DLY_MAX;
		end else begin
			case (c_state)
				S_IDLE		,
				S_MIN_TD_F	,
				S_DONE		: o_dly_ref	<= REF_DLY_MAX;
				S_FIX_TCLK	, 
				S_MIN_TQ_D	, 
				S_MIN_TD_F	, 
				S_MIN_TD_D	, 
				S_SAMPLE_D  : begin
					if (cnt_state == REF_CYCLES - 1) begin
						o_dly_ref	<= REF_DLY_MAX;
					end else if (cnt_state <= REF_CYCLES - 3) begin
						o_dly_ref	<= i_cff_out ? o_dly_ref - 2**(REF_DLY_BIT - 1 - cnt_state) :
												   o_dly_ref + 2**(REF_DLY_BIT - 1 - cnt_state) ;
					end else begin
						o_dly_ref	<= i_cff_out ? o_dly_ref - 1 : o_dly_ref + 1;
					end
				end
				default		: begin
					if (cnt_state == 2*REF_CYCLES - 1) begin
						o_dly_ref	<= REF_DLY_MAX;
					end else begin
						if (cnt_state[0]) begin
							if (cnt_state <= 2*(REF_CYCLES - 3)) begin
								o_dly_ref	<= i_cff_out ? o_dly_ref - 2**(REF_DLY_BIT - 1 - cnt_state[4:1]) :
														   o_dly_ref + 2**(REF_DLY_BIT - 1 - cnt_state[4:1]) ;
							end else begin
								o_dly_ref	<= i_cff_out ? o_dly_ref - 1 : o_dly_ref + 1;
							end
						end else begin
							o_dly_ref	<= o_dly_ref;
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
						M_SU_F	: o_dly_dat <= cnt_state[0] ? DAT_DLY_MAX : 0;
						M_HD_R	,
						M_HD_F	: o_dly_dat <= cnt_state[0] ? 0 : DAT_DLY_MAX;
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
				S_MIN_TD_D	: o_dly_dat <= o_dly_dat;
				S_MIN_TD_Q	: begin
					case(i_mode)
						M_SU_R	,
						M_SU_F	: o_dly_dat <= cnt_state[0] ? DAT_DLY_MAX : dly_dat;
						M_HD_R	,
						M_HD_F	: o_dly_dat <= cnt_state[0] ? 0           : dly_dat;
					endcase
				end
				S_SAMPLE_D	: o_dly_dat <= dly_dat - -1**(i_mode[1])*2*(cnt_smpls + 1);
				S_SAMPLE_Q	: begin
					case(i_mode)
						M_SU_R	,
						M_SU_F	: o_dly_dat <= cnt_state[0] ? DAT_DLY_MAX : dly_dat - -1**(i_mode[1])*2*(cnt_smpls + 1);
						M_HD_R	,
						M_HD_F	: o_dly_dat <= cnt_state[0] ? 0           : dly_dat - -1**(i_mode[1])*2*(cnt_smpls + 1);
					endcase
				end
				default		: o_dly_dat	<= 0;
			endcase
		end
	end

	always @(*) begin
		case(c_state)
			S_IDLE      : o_sigs_sel = 0;
			S_FIX_TCLK	: o_sigs_sel = 1;
			S_MIN_TQ_D	: o_sigs_sel = 0;
			S_MIN_TQ_Q	: o_sigs_sel = i_addr[0] ? 3:2;
			S_MIN_TD_F	: o_sigs_sel = i_addr[0] ? 3:2;
			S_MIN_TD_D	: o_sigs_sel = 0;
			S_MIN_TD_Q  : o_sigs_sel = i_addr[0] ? 3:2;
			S_SAMPLE_D  : o_sigs_sel = 0;
			S_SAMPLE_Q  : o_sigs_sel = i_addr[0] ? 3:2;
			S_DONE		: o_sigs_sel = 0;
		endcase
	end

	assign		o_edge_d	= i_mode[1] ^ i_mode[0];
	assign		o_edge_c	= 0;
	assign		o_edge_m	= (o_sigs_sel == 1) ? 0 : i_mode[1] ^ i_mode[0];

endmodule
