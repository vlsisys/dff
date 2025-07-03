// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: a_ref_gen.v
//	* Description	: 
// ==================================================

module a_ref_gen
(	
	output 				o_osc,
	output 				o_ref1,
	output 				o_ref2,
	input		[8:0]	i_dly_sel,
	input				i_test_clk,
	input				i_mode
);
	
	wire				w_imux_o;
	wire				w_dcell_o[0:9];
	assign	#(`T_REF_DLY_IMUX)	w_imux_o	= i_mode ?	~w_dcell_o[9]:
														~i_test_clk;

	b_dly_f64c8 i0(.o_out (w_dcell_o[0]), .i_in (w_imux_o    ), .i_dly_sel (i_dly_sel));
	b_dly_f64c8 i1(.o_out (w_dcell_o[1]), .i_in (w_dcell_o[0]), .i_dly_sel (i_dly_sel));
	b_dly_f64c8 i2(.o_out (w_dcell_o[2]), .i_in (w_dcell_o[1]), .i_dly_sel (i_dly_sel));
	b_dly_f64c8 i3(.o_out (w_dcell_o[3]), .i_in (w_dcell_o[2]), .i_dly_sel (i_dly_sel));
	b_dly_f64c8 i4(.o_out (w_dcell_o[4]), .i_in (w_dcell_o[3]), .i_dly_sel (i_dly_sel));
	b_dly_f64c8 i5(.o_out (w_dcell_o[5]), .i_in (w_dcell_o[4]), .i_dly_sel (i_dly_sel));
	b_dly_f64c8 i6(.o_out (w_dcell_o[6]), .i_in (w_dcell_o[5]), .i_dly_sel (i_dly_sel));
	b_dly_f64c8 i7(.o_out (w_dcell_o[7]), .i_in (w_dcell_o[6]), .i_dly_sel (i_dly_sel));
	b_dly_f64c8 i8(.o_out (w_dcell_o[8]), .i_in (w_dcell_o[7]), .i_dly_sel (i_dly_sel));
	b_dly_f64c8 i9(.o_out (w_dcell_o[9]), .i_in (w_dcell_o[8]), .i_dly_sel (i_dly_sel));

	assign	o_osc	= w_imux_o;
	assign	o_ref1	= w_dcell_o[4];
	assign	o_ref2	= w_dcell_o[5];

endmodule
