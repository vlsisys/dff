// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: u_dly_coarse8.v
//	* Description	: 
// ==================================================

`define		T_DLY_COARSE	60

module u_dly_coarse8
(	
	output reg			o_out,
	input				i_in,
	input		[2:0]	i_sel
);

	always @(*) begin
		case(i_sel)
			0:	o_out	= #(`T_DLY_COARSE*0)	i_in;
			1:	o_out	= #(`T_DLY_COARSE*1)	i_in;
			2:	o_out	= #(`T_DLY_COARSE*2)	i_in;
			3:	o_out	= #(`T_DLY_COARSE*3)	i_in;
			4:	o_out	= #(`T_DLY_COARSE*4)	i_in;
			5:	o_out	= #(`T_DLY_COARSE*5)	i_in;
			6:	o_out	= #(`T_DLY_COARSE*6)	i_in;
			7:	o_out	= #(`T_DLY_COARSE*7)	i_in;
		endcase
	end

endmodule
