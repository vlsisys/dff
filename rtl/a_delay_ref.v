// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: a_delay_ref.v
//	* Description	: 
// ==================================================

module a_delay_ref
(	
	output 				o_osc,
	output 				o_ref1,
	output 				o_ref2,
	input		[10:0]	i_dly,
	input				i_test_clk,
	input				i_osc_en
);
	
	wire				w_imux_o;
	wire				w_dcell_o[0:9];
	assign	#(`T_DLY_IMUX)	w_imux_o	= i_osc_en ? ~w_dcell_o[9]:~i_test_clk;

	b_dly_f64c32 i0(.o_out (w_dcell_o[0]), .i_in (w_imux_o    ), .i_dly (i_dly));
	b_dly_f64c32 i1(.o_out (w_dcell_o[1]), .i_in (w_dcell_o[0]), .i_dly (i_dly));
	b_dly_f64c32 i2(.o_out (w_dcell_o[2]), .i_in (w_dcell_o[1]), .i_dly (i_dly));
	b_dly_f64c32 i3(.o_out (w_dcell_o[3]), .i_in (w_dcell_o[2]), .i_dly (i_dly));
	b_dly_f64c32 i4(.o_out (w_dcell_o[4]), .i_in (w_dcell_o[3]), .i_dly (i_dly));

	b_dly_f64c32 i5(.o_out (w_dcell_o[5]), .i_in (w_dcell_o[4]), .i_dly (i_dly));
	b_dly_f64c32 i6(.o_out (w_dcell_o[6]), .i_in (w_dcell_o[5]), .i_dly (i_dly));
	b_dly_f64c32 i7(.o_out (w_dcell_o[7]), .i_in (w_dcell_o[6]), .i_dly (i_dly));
	b_dly_f64c32 i8(.o_out (w_dcell_o[8]), .i_in (w_dcell_o[7]), .i_dly (i_dly));
	b_dly_f64c32 i9(.o_out (w_dcell_o[9]), .i_in (w_dcell_o[8]), .i_dly (i_dly));

	assign	#(`T_DLY_BUF)	o_osc	= w_imux_o;
	assign	o_ref1	= w_dcell_o[4];
	assign	o_ref2	= w_dcell_o[5];

endmodule
