// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: u_dly_fine.v
//	* Description	: 
// ==================================================

`define			T_DLY_FINE_BASE		200
`define			T_DLY_FINE			2

module u_dly_fine
(	
	output 						o_out,
	input						i_in,
	input						i_sel
);

	wire						in_dly;
	assign	#(`T_DLY_FINE)		in_dly	= i_in;

	assign	#(`T_DLY_FINE_BASE)	o_out	= i_sel	?	in_dly: i_in;

endmodule
