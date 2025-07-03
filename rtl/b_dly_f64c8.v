// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: b_dly_f64c8.v
//	* Description	: 
// ==================================================

module b_dly_f64c8
(	
	output				o_out,
	input				i_in,
	input		[8:0]	i_dly_sel
);

	wire			w_dly_fine;
	wire	[63:0]	w_sel_fine;

	u_thermometer64
	thermometer64(	
		.o_out	(w_sel_fine		),
		.i_in	(i_dly_sel[5:0]	)
	);


	c_dly_fine64
	c_dly_fine64(
		.o_out	(w_dly_fine		),
		.i_in	(i_in			),
		.i_sel	(w_sel_fine		)
	);

	u_dly_coarse8
	u_dly_coarse8(
		.o_out	(o_out			),
		.i_in	(w_dly_fine		),
		.i_sel	(i_dly_sel[8:6] )
	);

endmodule
