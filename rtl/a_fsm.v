// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: a_fsm.v
//	* Description	: 
// ==================================================

module a_fsm
(	
	output reg	[3:0]	o_dut_addr,
	output reg	[9:0]	o_ref_dly,
	output reg	[8:0]	o_dat_dly,
	output reg			o_edge_d,
	output reg			o_edge_c,
	output reg			o_edge_m,
	output reg			o_sigs_sel,
	output reg			o_check,
	input		[1:0]	i_mode,
	input				i_start,
	input				i_cff_out,
	input				i_clk,
	input				i_rstn
);

	
// --------------------------------------------------
// Mode
	localparam	REF_DLY_BIT	= 10;
	localparam	DAT_DLY_BIT	= 9;

	localparam	NUM_SAMPLE	= 4;
	localparam	NUM_DUT		= 40;

	localparam	M_SU_R		= 2'd0;
	localparam	M_SU_F		= 2'd1;
	localparam	M_HD_R		= 2'd2;
	localparam	M_HD_F		= 2'd3;

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

	reg		[3:0]	cnt_state;
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

	reg		[3:0]	cnt_addr;
	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			cnt_addr <= 0;
		end else begin
			case(c_state)
				S_DONE	: cnt_addr <= cnt_addr + 1;
				S_IDLE	: cnt_addr <= 0;
			endcase
		end
	end

	always @(*) begin
		case(c_state)
			S_IDLE      : n_state = i_start                        ? c_state : S_FIX_TCLK ;
			S_FIX_TCLK	: n_state = (cnt_state != REF_DLY_BIT + 1) ? c_state : S_MIN_TQ_D ;
			S_MIN_TQ_D	: n_state = (cnt_state != REF_DLY_BIT + 1) ? c_state : S_MIN_TQ_Q ;
			S_MIN_TQ_Q	: n_state = (cnt_state != REF_DLY_BIT + 1) ? c_state : S_MIN_TD_D0;
			S_MIN_TD_D0 : n_state = (cnt_state != DAT_DLY_BIT + 1) ? c_state : S_MIN_TD_D1;
			S_MIN_TD_D1 : n_state = (cnt_state != REF_DLY_BIT + 1) ? c_state : S_MIN_TD_Q ;
			S_MIN_TD_Q  : n_state = (cnt_state != REF_DLY_BIT + 1) ? c_state : S_SAMPLE_D ;
			S_SAMPLE_D  : n_state = (cnt_state != REF_DLY_BIT + 1) ? c_state : S_SAMPLE_Q ;
			S_SAMPLE_Q  : n_state = (cnt_state != REF_DLY_BIT + 1) ? c_state :
				                    (cnt_smpls == NUM_SAMPLE  - 1) ? S_DONE  : S_SAMPLE_D ;
			S_DONE		: n_state = (cnt_addr  == NUM_DUT     - 1) ? S_IDLE  : S_FIX_TCLK ;
		endcase
	end

	// Output Logic
	always @(posedge i_clk or negedge i_rstn) begin
		if (!i_rstn) begin
			o_ref_dly	<= 2**REF_DLY_BIT-1;
		end else begin
			if (c_state != S_IDLE || c_state != S_MIN_TD_D0 || c_state != S_DONE) begin
				if (cnt_state == REF_DLY_BIT + 1) begin
					o_ref_dly	<= 2**REF_DLY_BIT-1;
				end else begin
					if (REF_DLY_BIT - 1 - cnt_state >= 0) begin
						o_ref_dly	<= i_cff_out ? o_ref_dly - 2**(REF_DLY_BIT - 1 - cnt_state) :
							                       o_ref_dly + 2**(REF_DLY_BIT - 1 - cnt_state) ;
					end else begin
						o_ref_dly	<= i_cff_out ? o_ref_dly - 1 : o_ref_dly + 1;
					end
				end
			end else begin
				o_ref_dly	<= 2**REF_DLY_BIT-1;
			end
		end
	end

	reg		[DAT_DLY_BIT-1:0]	dat_dly;
	always @(posedge i_clk or negedge i_rstn) begin
		if (!i_rstn) begin
			dat_dly	<= 0;
		end else begin
			if (c_state == S_MIN_TD_D0) begin
				dat_dly	<= o_dat_dly;
			end else begin
				dat_dly	<= 0;
			end
		end
	end

	always @(posedge i_clk or negedge i_rstn) begin
		if (!i_rstn) begin
			o_dat_dly	<= 0;
		end else begin
			case (c_state)
				S_MIN_TQ_D	,
				S_MIN_TQ_Q	: begin
					case (i_mode[1])
						0: o_dat_dly <= 0;
						1: o_dat_dly <= 2**DAT_DLY_BIT - 1;
					endcase
				end
				S_MIN_TD_D0	: begin
					if (p_state == S_MIN_TQ_Q) begin
						o_dat_dly	<= i_mode[1] ? 2**DAT_DLY_BIT - 1 : 0;
					end else begin
						if (DAT_DLY_BIT - 1 - cnt_state >= 0) begin
							o_dat_dly	<= i_cff_out ? o_dat_dly + -1**(i_mode[1])*2**(DAT_DLY_BIT - 1 - cnt_state) :
													   o_dat_dly - -1**(i_mode[1])*2**(DAT_DLY_BIT - 1 - cnt_state) ;
						end else begin
							o_dat_dly	<= i_cff_out ? o_dat_dly + -1**(-i_mode[1])*1 : 
								                       o_dat_dly - -1**(-i_mode[1])*1;
						end
					end
				end
				S_SAMPLE_D	,
				S_SAMPLE_Q	: begin
					o_dat_dly <= dat_dly - -1**(i_mode[1])*(cnt_smpls + 1);
				end
				default		: o_dat_dly	<= 0;
			endcase
		end
	end

endmodule
