// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: u_dec3to8.v
//	* Description	: 
// ==================================================

module	u_dec3to8
(	
	output		[7:0]	o_out,
	input		[2:0]	i_in
);

	assign	o_out = 8'b1 << i_in;

endmodule
