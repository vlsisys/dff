// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: u_dly_coarse.v
//	* Description	: 
// ==================================================

`define			T_DLY_COARSE_IMUX	80
`define			T_DLY_COARSE_INV	50
module u_dly_coarse
(	
	output 						o_out_l,
	output 						o_out_r,
	input						i_in_l,
	input						i_in_r,
	input						i_sel
);

	assign	#(`T_DLY_COARSE_INV)	o_out_r	= i_in_l;
	assign	#(`T_DLY_COARSE_IMUX)	o_out_l	= i_sel ? o_out_r : i_in_r;

endmodule
