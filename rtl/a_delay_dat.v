// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: a_delay_dat.v
//	* Description	: 
// ==================================================

module a_delay_dat
(	
	output				o_out,
	input				i_in,
	input		[8:0]	i_dly,
	input				i_edge_d
);
	
	wire				out;

	b_dly_f64c8
	u_b_dly_f64c8(
		.o_out		(out	),
		.i_in		(i_in	),
		.i_dly		(i_dly	)
	);

	assign	#(`T_DLY_XOR)	o_out = out ^ i_edge_d;

endmodule
