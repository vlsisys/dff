// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: c_dly_fine64.v
//	* Description	: 
// ==================================================

module c_dly_fine64
(	
	output				o_out,
	input				i_in,
	input		[63:0]	i_sel
);

	wire	[62:0]	w;
	u_dly_fine	i00(.o_out(w[ 0]), .i_in(i_in ), .i_sel(i_sel[ 0]));
	u_dly_fine	i01(.o_out(w[ 1]), .i_in(w[ 0]), .i_sel(i_sel[ 1]));
	u_dly_fine	i02(.o_out(w[ 2]), .i_in(w[ 1]), .i_sel(i_sel[ 2]));
	u_dly_fine	i03(.o_out(w[ 3]), .i_in(w[ 2]), .i_sel(i_sel[ 3]));
	u_dly_fine	i04(.o_out(w[ 4]), .i_in(w[ 3]), .i_sel(i_sel[ 4]));
	u_dly_fine	i05(.o_out(w[ 5]), .i_in(w[ 4]), .i_sel(i_sel[ 5]));
	u_dly_fine	i06(.o_out(w[ 6]), .i_in(w[ 5]), .i_sel(i_sel[ 6]));
	u_dly_fine	i07(.o_out(w[ 7]), .i_in(w[ 6]), .i_sel(i_sel[ 7]));
	u_dly_fine	i08(.o_out(w[ 8]), .i_in(w[ 7]), .i_sel(i_sel[ 8]));
	u_dly_fine	i09(.o_out(w[ 9]), .i_in(w[ 8]), .i_sel(i_sel[ 9]));
	u_dly_fine	i10(.o_out(w[10]), .i_in(w[ 9]), .i_sel(i_sel[10]));
	u_dly_fine	i11(.o_out(w[11]), .i_in(w[10]), .i_sel(i_sel[11]));
	u_dly_fine	i12(.o_out(w[12]), .i_in(w[11]), .i_sel(i_sel[12]));
	u_dly_fine	i13(.o_out(w[13]), .i_in(w[12]), .i_sel(i_sel[13]));
	u_dly_fine	i14(.o_out(w[14]), .i_in(w[13]), .i_sel(i_sel[14]));
	u_dly_fine	i15(.o_out(w[15]), .i_in(w[14]), .i_sel(i_sel[15]));
	u_dly_fine	i16(.o_out(w[16]), .i_in(w[15]), .i_sel(i_sel[16]));
	u_dly_fine	i17(.o_out(w[17]), .i_in(w[16]), .i_sel(i_sel[17]));
	u_dly_fine	i18(.o_out(w[18]), .i_in(w[17]), .i_sel(i_sel[18]));
	u_dly_fine	i19(.o_out(w[19]), .i_in(w[18]), .i_sel(i_sel[19]));
	u_dly_fine	i20(.o_out(w[20]), .i_in(w[19]), .i_sel(i_sel[20]));
	u_dly_fine	i21(.o_out(w[21]), .i_in(w[20]), .i_sel(i_sel[21]));
	u_dly_fine	i22(.o_out(w[22]), .i_in(w[21]), .i_sel(i_sel[22]));
	u_dly_fine	i23(.o_out(w[23]), .i_in(w[22]), .i_sel(i_sel[23]));
	u_dly_fine	i24(.o_out(w[24]), .i_in(w[23]), .i_sel(i_sel[24]));
	u_dly_fine	i25(.o_out(w[25]), .i_in(w[24]), .i_sel(i_sel[25]));
	u_dly_fine	i26(.o_out(w[26]), .i_in(w[25]), .i_sel(i_sel[26]));
	u_dly_fine	i27(.o_out(w[27]), .i_in(w[26]), .i_sel(i_sel[27]));
	u_dly_fine	i28(.o_out(w[28]), .i_in(w[27]), .i_sel(i_sel[28]));
	u_dly_fine	i29(.o_out(w[29]), .i_in(w[28]), .i_sel(i_sel[29]));
	u_dly_fine	i30(.o_out(w[30]), .i_in(w[29]), .i_sel(i_sel[30]));
	u_dly_fine	i31(.o_out(w[31]), .i_in(w[30]), .i_sel(i_sel[31]));
	u_dly_fine	i32(.o_out(w[32]), .i_in(w[31]), .i_sel(i_sel[32]));
	u_dly_fine	i33(.o_out(w[33]), .i_in(w[32]), .i_sel(i_sel[33]));
	u_dly_fine	i34(.o_out(w[34]), .i_in(w[33]), .i_sel(i_sel[34]));
	u_dly_fine	i35(.o_out(w[35]), .i_in(w[34]), .i_sel(i_sel[35]));
	u_dly_fine	i36(.o_out(w[36]), .i_in(w[35]), .i_sel(i_sel[36]));
	u_dly_fine	i37(.o_out(w[37]), .i_in(w[36]), .i_sel(i_sel[37]));
	u_dly_fine	i38(.o_out(w[38]), .i_in(w[37]), .i_sel(i_sel[38]));
	u_dly_fine	i39(.o_out(w[39]), .i_in(w[38]), .i_sel(i_sel[39]));
	u_dly_fine	i40(.o_out(w[40]), .i_in(w[39]), .i_sel(i_sel[40]));
	u_dly_fine	i41(.o_out(w[41]), .i_in(w[40]), .i_sel(i_sel[41]));
	u_dly_fine	i42(.o_out(w[42]), .i_in(w[41]), .i_sel(i_sel[42]));
	u_dly_fine	i43(.o_out(w[43]), .i_in(w[42]), .i_sel(i_sel[43]));
	u_dly_fine	i44(.o_out(w[44]), .i_in(w[43]), .i_sel(i_sel[44]));
	u_dly_fine	i45(.o_out(w[45]), .i_in(w[44]), .i_sel(i_sel[45]));
	u_dly_fine	i46(.o_out(w[46]), .i_in(w[45]), .i_sel(i_sel[46]));
	u_dly_fine	i47(.o_out(w[47]), .i_in(w[46]), .i_sel(i_sel[47]));
	u_dly_fine	i48(.o_out(w[48]), .i_in(w[47]), .i_sel(i_sel[48]));
	u_dly_fine	i49(.o_out(w[49]), .i_in(w[48]), .i_sel(i_sel[49]));
	u_dly_fine	i50(.o_out(w[50]), .i_in(w[49]), .i_sel(i_sel[50]));
	u_dly_fine	i51(.o_out(w[51]), .i_in(w[50]), .i_sel(i_sel[51]));
	u_dly_fine	i52(.o_out(w[52]), .i_in(w[51]), .i_sel(i_sel[52]));
	u_dly_fine	i53(.o_out(w[53]), .i_in(w[52]), .i_sel(i_sel[53]));
	u_dly_fine	i54(.o_out(w[54]), .i_in(w[53]), .i_sel(i_sel[54]));
	u_dly_fine	i55(.o_out(w[55]), .i_in(w[54]), .i_sel(i_sel[55]));
	u_dly_fine	i56(.o_out(w[56]), .i_in(w[55]), .i_sel(i_sel[56]));
	u_dly_fine	i57(.o_out(w[57]), .i_in(w[56]), .i_sel(i_sel[57]));
	u_dly_fine	i58(.o_out(w[58]), .i_in(w[57]), .i_sel(i_sel[58]));
	u_dly_fine	i59(.o_out(w[59]), .i_in(w[58]), .i_sel(i_sel[59]));
	u_dly_fine	i60(.o_out(w[60]), .i_in(w[59]), .i_sel(i_sel[60]));
	u_dly_fine	i61(.o_out(w[61]), .i_in(w[60]), .i_sel(i_sel[61]));
	u_dly_fine	i62(.o_out(w[62]), .i_in(w[61]), .i_sel(i_sel[62]));
	u_dly_fine	i63(.o_out(o_out), .i_in(w[62]), .i_sel(i_sel[63]));

endmodule
