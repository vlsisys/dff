// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: c_dly_coarse8.v
//	* Description	: 
// ==================================================

`include	"u_dly_coarse.v"

module c_dly_coarse8
(	
	output				o_out,
	input				i_in,
	input		[7:0]	i_sel
);

	wire	[6:0]	w_u;
	wire	[6:0]	w_l;
	u_dly_coarse i00(.o_out_l(o_out  ), .i_in_l(i_in   ), .o_out_r(w_l[ 0]), .i_in_r(w_u[ 0] ), .i_sel(i_sel[ 0]));
	u_dly_coarse i01(.o_out_l(w_u[ 0]), .i_in_l(w_l[ 0]), .o_out_r(w_l[ 1]), .i_in_r(w_u[ 1] ), .i_sel(i_sel[ 1]));
	u_dly_coarse i02(.o_out_l(w_u[ 1]), .i_in_l(w_l[ 1]), .o_out_r(w_l[ 2]), .i_in_r(w_u[ 2] ), .i_sel(i_sel[ 2]));
	u_dly_coarse i03(.o_out_l(w_u[ 2]), .i_in_l(w_l[ 2]), .o_out_r(w_l[ 3]), .i_in_r(w_u[ 3] ), .i_sel(i_sel[ 3]));
	u_dly_coarse i04(.o_out_l(w_u[ 3]), .i_in_l(w_l[ 3]), .o_out_r(w_l[ 4]), .i_in_r(w_u[ 4] ), .i_sel(i_sel[ 4]));
	u_dly_coarse i05(.o_out_l(w_u[ 4]), .i_in_l(w_l[ 4]), .o_out_r(w_l[ 5]), .i_in_r(w_u[ 5] ), .i_sel(i_sel[ 5]));
	u_dly_coarse i06(.o_out_l(w_u[ 5]), .i_in_l(w_l[ 5]), .o_out_r(w_l[ 6]), .i_in_r(w_u[ 6] ), .i_sel(i_sel[ 6]));
	u_dly_coarse i07(.o_out_l(w_u[ 6]), .i_in_l(w_l[ 6]), .o_out_r(       ), .i_in_r(1'b0    ), .i_sel(i_sel[ 7]));

endmodule

