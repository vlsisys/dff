// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: b_dly_line.v
//	* Description	: 
// ==================================================

`include	"b_dly_f64c4.v"

module b_dly_line
(	
	output				o_out,
	input				i_in,
	input		[7:0]	i_dly_sel
);

	b_dly_f64c4
	u_b_dly_f64c4(
		.o_out				(o_out				),
		.i_in				(i_in				),
		.i_dly_sel			(i_dly_sel			)
	);


endmodule
