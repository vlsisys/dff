// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: u_dly_coarse4.v
//	* Description	: 
// ==================================================

module u_dly_coarse4
(	
	output reg			o_out,
	input				i_in,
	input		[1:0]	i_sel
);

	always @(*) begin
		case(i_sel)
			0:	o_out	= #(0*`T_DLY_COARSE) i_in;
			1:	o_out	= #(1*`T_DLY_COARSE) i_in;
			2:	o_out	= #(2*`T_DLY_COARSE) i_in;
			3:	o_out	= #(3*`T_DLY_COARSE) i_in;
		endcase
	end

endmodule
