// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: u_tile.v
//	* Description	: 
// ==================================================

module u_tile
#(	
	parameter	T_SU0	= 40,
	parameter	T_SU1	= 45,
	parameter	T_SU2	= 50,
	parameter	T_SU3	= 55,
	parameter	T_HD0	= 20,
	parameter	T_HD1	= 21,
	parameter	T_HD2	= 22,
	parameter	T_HD3	= 23,
	parameter	T_CQ0	= 100,
	parameter	T_CQ1	= 104,
	parameter	T_CQ2	= 108,
	parameter	T_CQ3	= 112
)
(	
	output reg			o_tile,
	input				i_tile,
	input				i_d,
	input				i_clk,
	input				i_edge_sel,
	input				i_tile_sel,
	input	[1:0]		i_duts_sel,
	input	[1:0]		i_sigs_sel
);

	wire				d;
	wire				clk;
	wire	[1:0]		sigs_sel;
	assign	#(`T_DLY_NAND2)		d			= ~(i_d   & i_tile_sel);
	assign	#(`T_DLY_NAND2)		clk			= ~(i_clk & i_tile_sel);
	assign	#(`T_DLY_BUF)		sigs_sel	= i_sigs_sel;

	wire				dutout[0:3];
	u_dut #( .T_SU(T_SU0), .T_HD(T_HD0), .T_CQ(T_CQ0)) dut0(.o_mux(dutout[0]), .i_d (d), .i_clk(clk), .i_sel(sigs_sel));
	u_dut #( .T_SU(T_SU1), .T_HD(T_HD1), .T_CQ(T_CQ1)) dut1(.o_mux(dutout[1]), .i_d (d), .i_clk(clk), .i_sel(sigs_sel));
	u_dut #( .T_SU(T_SU2), .T_HD(T_HD2), .T_CQ(T_CQ2)) dut2(.o_mux(dutout[2]), .i_d (d), .i_clk(clk), .i_sel(sigs_sel));
	u_dut #( .T_SU(T_SU3), .T_HD(T_HD3), .T_CQ(T_CQ3)) dut3(.o_mux(dutout[3]), .i_d (d), .i_clk(clk), .i_sel(sigs_sel));

	reg					dut_muxout;
	wire				xor_out;
	always @(*) begin
		case(i_duts_sel)
			0:	dut_muxout	= #(`T_DLY_MUX4) dutout[0];
			1:	dut_muxout	= #(`T_DLY_MUX4) dutout[1];
			2:	dut_muxout	= #(`T_DLY_MUX4) dutout[2];
			3:	dut_muxout	= #(`T_DLY_MUX4) dutout[3];
		endcase
	end
	
	assign	#(`T_DLY_XOR)		xor_out		= dut_muxout ^ i_edge_sel;

	always @(*) begin
		case(i_tile_sel)
			0:	o_tile	= #(`T_DLY_MUX2) i_tile  ;
			1:	o_tile	= #(`T_DLY_MUX2) xor_out ;
		endcase
	end

endmodule
