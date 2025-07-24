// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: u_dly_coarse32.v
//	* Description	: 
// ==================================================

module u_dly_coarse32
(	
	output reg			o_out,
	input				i_in,
	input		[4:0]	i_sel
);

	always @(*) begin
		case(i_sel)
			 0:	o_out	= #(`T_DLY_COARSE* 0)	i_in;
			 1:	o_out	= #(`T_DLY_COARSE* 1)	i_in;
			 2:	o_out	= #(`T_DLY_COARSE* 2)	i_in;
			 3:	o_out	= #(`T_DLY_COARSE* 3)	i_in;
			 4:	o_out	= #(`T_DLY_COARSE* 4)	i_in;
			 5:	o_out	= #(`T_DLY_COARSE* 5)	i_in;
			 6:	o_out	= #(`T_DLY_COARSE* 6)	i_in;
			 7:	o_out	= #(`T_DLY_COARSE* 7)	i_in;
			 8:	o_out	= #(`T_DLY_COARSE* 8)	i_in;
			 9:	o_out	= #(`T_DLY_COARSE* 9)	i_in;
			10:	o_out	= #(`T_DLY_COARSE*10)	i_in;
			11:	o_out	= #(`T_DLY_COARSE*11)	i_in;
			12:	o_out	= #(`T_DLY_COARSE*12)	i_in;
			13:	o_out	= #(`T_DLY_COARSE*13)	i_in;
			14:	o_out	= #(`T_DLY_COARSE*14)	i_in;
			15:	o_out	= #(`T_DLY_COARSE*15)	i_in;
			16:	o_out	= #(`T_DLY_COARSE*16)	i_in;
			17:	o_out	= #(`T_DLY_COARSE*17)	i_in;
			18:	o_out	= #(`T_DLY_COARSE*18)	i_in;
			19:	o_out	= #(`T_DLY_COARSE*19)	i_in;
			20:	o_out	= #(`T_DLY_COARSE*20)	i_in;
			21:	o_out	= #(`T_DLY_COARSE*21)	i_in;
			22:	o_out	= #(`T_DLY_COARSE*22)	i_in;
			23:	o_out	= #(`T_DLY_COARSE*23)	i_in;
			24:	o_out	= #(`T_DLY_COARSE*24)	i_in;
			25:	o_out	= #(`T_DLY_COARSE*25)	i_in;
			26:	o_out	= #(`T_DLY_COARSE*26)	i_in;
			27:	o_out	= #(`T_DLY_COARSE*27)	i_in;
			28:	o_out	= #(`T_DLY_COARSE*28)	i_in;
			29:	o_out	= #(`T_DLY_COARSE*29)	i_in;
			30:	o_out	= #(`T_DLY_COARSE*30)	i_in;
			31:	o_out	= #(`T_DLY_COARSE*31)	i_in;
		endcase
	end

endmodule
