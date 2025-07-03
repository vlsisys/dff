// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: u_thermometer64.v
//	* Description	: 
// ==================================================

module u_thermometer64
(	
	output reg	[63:0]	o_out,
	input		[ 5:0]	i_in
);

	always @(*) begin
		case(i_in)
			6'd0	:	o_out	= 64'h0000_0000_0000_0000;
			6'd1	:	o_out	= 64'h0000_0000_0000_0001;
			6'd2	:	o_out	= 64'h0000_0000_0000_0003;
			6'd3	:	o_out	= 64'h0000_0000_0000_0007;
			6'd4	:	o_out	= 64'h0000_0000_0000_000F;
			6'd5	:	o_out	= 64'h0000_0000_0000_001F;
			6'd6	:	o_out	= 64'h0000_0000_0000_003F;
			6'd7	:	o_out	= 64'h0000_0000_0000_007F;
			6'd8	:	o_out	= 64'h0000_0000_0000_00FF;
			6'd9	:	o_out	= 64'h0000_0000_0000_01FF;
			6'd10	:	o_out	= 64'h0000_0000_0000_03FF;
			6'd11	:	o_out	= 64'h0000_0000_0000_07FF;
			6'd12	:	o_out	= 64'h0000_0000_0000_0FFF;
			6'd13	:	o_out	= 64'h0000_0000_0000_1FFF;
			6'd14	:	o_out	= 64'h0000_0000_0000_3FFF;
			6'd15	:	o_out	= 64'h0000_0000_0000_7FFF;
			6'd16	:	o_out	= 64'h0000_0000_0000_FFFF;
			6'd17	:	o_out	= 64'h0000_0000_0001_FFFF;
			6'd18	:	o_out	= 64'h0000_0000_0003_FFFF;
			6'd19	:	o_out	= 64'h0000_0000_0007_FFFF;
			6'd20	:	o_out	= 64'h0000_0000_000F_FFFF;
			6'd21	:	o_out	= 64'h0000_0000_001F_FFFF;
			6'd22	:	o_out	= 64'h0000_0000_003F_FFFF;
			6'd23	:	o_out	= 64'h0000_0000_007F_FFFF;
			6'd24	:	o_out	= 64'h0000_0000_00FF_FFFF;
			6'd25	:	o_out	= 64'h0000_0000_01FF_FFFF;
			6'd26	:	o_out	= 64'h0000_0000_03FF_FFFF;
			6'd27	:	o_out	= 64'h0000_0000_07FF_FFFF;
			6'd28	:	o_out	= 64'h0000_0000_0FFF_FFFF;
			6'd29	:	o_out	= 64'h0000_0000_1FFF_FFFF;
			6'd30	:	o_out	= 64'h0000_0000_3FFF_FFFF;
			6'd31	:	o_out	= 64'h0000_0000_7FFF_FFFF;
			6'd32	:	o_out	= 64'h0000_0000_FFFF_FFFF;
			6'd33	:	o_out	= 64'h0000_0001_FFFF_FFFF;
			6'd34	:	o_out	= 64'h0000_0003_FFFF_FFFF;
			6'd35	:	o_out	= 64'h0000_0007_FFFF_FFFF;
			6'd36	:	o_out	= 64'h0000_000F_FFFF_FFFF;
			6'd37	:	o_out	= 64'h0000_001F_FFFF_FFFF;
			6'd38	:	o_out	= 64'h0000_003F_FFFF_FFFF;
			6'd39	:	o_out	= 64'h0000_007F_FFFF_FFFF;
			6'd40	:	o_out	= 64'h0000_00FF_FFFF_FFFF;
			6'd41	:	o_out	= 64'h0000_01FF_FFFF_FFFF;
			6'd42	:	o_out	= 64'h0000_03FF_FFFF_FFFF;
			6'd43	:	o_out	= 64'h0000_07FF_FFFF_FFFF;
			6'd44	:	o_out	= 64'h0000_0FFF_FFFF_FFFF;
			6'd45	:	o_out	= 64'h0000_1FFF_FFFF_FFFF;
			6'd46	:	o_out	= 64'h0000_3FFF_FFFF_FFFF;
			6'd47	:	o_out	= 64'h0000_7FFF_FFFF_FFFF;
			6'd48	:	o_out	= 64'h0000_FFFF_FFFF_FFFF;
			6'd49	:	o_out	= 64'h0001_FFFF_FFFF_FFFF;
			6'd50	:	o_out	= 64'h0003_FFFF_FFFF_FFFF;
			6'd51	:	o_out	= 64'h0007_FFFF_FFFF_FFFF;
			6'd52	:	o_out	= 64'h000F_FFFF_FFFF_FFFF;
			6'd53	:	o_out	= 64'h001F_FFFF_FFFF_FFFF;
			6'd54	:	o_out	= 64'h003F_FFFF_FFFF_FFFF;
			6'd55	:	o_out	= 64'h007F_FFFF_FFFF_FFFF;
			6'd56	:	o_out	= 64'h00FF_FFFF_FFFF_FFFF;
			6'd57	:	o_out	= 64'h01FF_FFFF_FFFF_FFFF;
			6'd58	:	o_out	= 64'h03FF_FFFF_FFFF_FFFF;
			6'd59	:	o_out	= 64'h07FF_FFFF_FFFF_FFFF;
			6'd60	:	o_out	= 64'h0FFF_FFFF_FFFF_FFFF;
			6'd61	:	o_out	= 64'h1FFF_FFFF_FFFF_FFFF;
			6'd62	:	o_out	= 64'h3FFF_FFFF_FFFF_FFFF;
			6'd63	:	o_out	= 64'h7FFF_FFFF_FFFF_FFFF;
		endcase
	end

endmodule
