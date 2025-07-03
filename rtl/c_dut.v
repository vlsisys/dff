// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: c_dut_tile.v
//	* Description	: 
// ==================================================

`define			T_DLY_AND2		50
`define			T_DLY_MUX4		50

module c_dut_tile
#(	
	parameter	T_SU0	= 40,
	parameter	T_SU1	= 42,
	parameter	T_SU2	= 44,
	parameter	T_SU3	= 46,
	parameter	T_SU4	= 48,
	parameter	T_SU5	= 50,
	parameter	T_SU6	= 52,
	parameter	T_SU7	= 54,
	parameter	T_HD0	= 20,
	parameter	T_HD1	= 22,
	parameter	T_HD2	= 24,
	parameter	T_HD3	= 26,
	parameter	T_HD4	= 28,
	parameter	T_HD5	= 30,
	parameter	T_HD6	= 32,
	parameter	T_HD7	= 34,
	parameter	T_CQ0	= 100,
	parameter	T_CQ1	= 120,
	parameter	T_CQ2	= 140,
	parameter	T_CQ3	= 160,
	parameter	T_CQ4	= 180,
	parameter	T_CQ5	= 200,
	parameter	T_CQ6	= 220,
	parameter	T_CQ7	= 240
)
(	
	output reg			o_mux,
	input				i_d,
	input				i_clk,
	input				i_sel_tile,
	input	[1:0]		i_sel_dut,
	input	[1:0]		i_sel_sig
);
	
	wire		dut_q	[0:7] ;

	wire				gated_d		[0:3];
	wire				gated_clk	[0:3];
	and	#(`T_DLY_AND2)	u_and_d0	(gated_d  [0], i_d  , i_sel_tile);
	and	#(`T_DLY_AND2)	u_and_d1	(gated_d  [1], i_d  , i_sel_tile);
	and	#(`T_DLY_AND2)	u_and_d2	(gated_d  [2], i_d  , i_sel_tile);
	and	#(`T_DLY_AND2)	u_and_d3	(gated_d  [3], i_d  , i_sel_tile);
	and	#(`T_DLY_AND2)	u_and_clk0	(gated_clk[0], i_clk, i_sel_tile);
	and	#(`T_DLY_AND2)	u_and_clk1	(gated_clk[1], i_clk, i_sel_tile);
	and	#(`T_DLY_AND2)	u_and_clk2	(gated_clk[2], i_clk, i_sel_tile);
	and	#(`T_DLY_AND2)	u_and_clk3	(gated_clk[3], i_clk, i_sel_tile);

	//	T_SU	: Setup Time
	//	T_HD	: Hold  Time
	//	T_CQ	: CLK-to-Q 
	dff #(.T_SU(T_SU0), .T_HD(T_HD0), .T_CQ(T_CQ0)) dut0(.o_q(dut_q[0]), .i_d(gated_d[0]), .i_clk(gated_clk[0]), .i_rstn(1'b1));
	dff #(.T_SU(T_SU1), .T_HD(T_HD1), .T_CQ(T_CQ1)) dut1(.o_q(dut_q[1]), .i_d(gated_d[0]), .i_clk(gated_clk[0]), .i_rstn(1'b1));
	dff #(.T_SU(T_SU2), .T_HD(T_HD2), .T_CQ(T_CQ2)) dut2(.o_q(dut_q[2]), .i_d(gated_d[1]), .i_clk(gated_clk[1]), .i_rstn(1'b1));
	dff #(.T_SU(T_SU3), .T_HD(T_HD3), .T_CQ(T_CQ3)) dut3(.o_q(dut_q[3]), .i_d(gated_d[1]), .i_clk(gated_clk[1]), .i_rstn(1'b1));
	dff #(.T_SU(T_SU4), .T_HD(T_HD4), .T_CQ(T_CQ4)) dut4(.o_q(dut_q[4]), .i_d(gated_d[2]), .i_clk(gated_clk[2]), .i_rstn(1'b1));
	dff #(.T_SU(T_SU5), .T_HD(T_HD5), .T_CQ(T_CQ5)) dut5(.o_q(dut_q[5]), .i_d(gated_d[2]), .i_clk(gated_clk[2]), .i_rstn(1'b1));
	dff #(.T_SU(T_SU6), .T_HD(T_HD6), .T_CQ(T_CQ6)) dut6(.o_q(dut_q[6]), .i_d(gated_d[3]), .i_clk(gated_clk[3]), .i_rstn(1'b1));
	dff #(.T_SU(T_SU7), .T_HD(T_HD7), .T_CQ(T_CQ7)) dut7(.o_q(dut_q[7]), .i_d(gated_d[3]), .i_clk(gated_clk[3]), .i_rstn(1'b1));

	wire		dly_d	[0:3];
	wire		dly_clk	[0:3];
	wire		dly_q	[0:7];

	assign	#(`T_DLY_MUX4)	dly_d[0]	= gated_d[0];
	assign	#(`T_DLY_MUX4)	dly_d[1]	= gated_d[1];
	assign	#(`T_DLY_MUX4)	dly_d[2]	= gated_d[2];
	assign	#(`T_DLY_MUX4)	dly_d[3]	= gated_d[3];

	assign	#(`T_DLY_MUX4)	dly_clk[0]	= gated_clk[0];
	assign	#(`T_DLY_MUX4)	dly_clk[1]	= gated_clk[1];
	assign	#(`T_DLY_MUX4)	dly_clk[2]	= gated_clk[2];
	assign	#(`T_DLY_MUX4)	dly_clk[3]	= gated_clk[3];

	assign	#(`T_DLY_MUX4)	dly_q[0]	= dut_q[0];
	assign	#(`T_DLY_MUX4)	dly_q[1]	= dut_q[1];
	assign	#(`T_DLY_MUX4)	dly_q[2]	= dut_q[2];
	assign	#(`T_DLY_MUX4)	dly_q[3]	= dut_q[3];
	assign	#(`T_DLY_MUX4)	dly_q[4]	= dut_q[4];
	assign	#(`T_DLY_MUX4)	dly_q[5]	= dut_q[5];
	assign	#(`T_DLY_MUX4)	dly_q[6]	= dut_q[6];
	assign	#(`T_DLY_MUX4)	dly_q[7]	= dut_q[7];

	reg			mux_dut[0:3];

	always @(*) begin
		case(i_sel_sig)
			0:	mux_dut[0]	= dly_d		[0];
			1:	mux_dut[0]	= dly_clk	[0];
			2:	mux_dut[0]	= dly_q		[0];
			3:	mux_dut[0]	= dly_q		[1];
		endcase
	end

	always @(*) begin
		case(i_sel_sig)
			0:	mux_dut[1]	= dly_d		[1];
			1:	mux_dut[1]	= dly_clk	[1];
			2:	mux_dut[1]	= dly_q		[2];
			3:	mux_dut[1]	= dly_q		[3];
		endcase
	end

	always @(*) begin
		case(i_sel_sig)
			0:	mux_dut[2]	= dly_d		[2];
			1:	mux_dut[2]	= dly_clk	[2];
			2:	mux_dut[2]	= dly_q		[4];
			3:	mux_dut[2]	= dly_q		[5];
		endcase
	end

	always @(*) begin
		case(i_sel_sig)
			0:	mux_dut[3]	= dly_d		[3];
			1:	mux_dut[3]	= dly_clk	[3];
			2:	mux_dut[3]	= dly_q		[6];
			3:	mux_dut[3]	= dly_q		[7];
		endcase
	end

	wire		dly_mux_dut[0:3];

	assign	#(`T_DLY_MUX4)	dly_mux_dut[0]	= mux_dut[0];
	assign	#(`T_DLY_MUX4)	dly_mux_dut[1]	= mux_dut[1];
	assign	#(`T_DLY_MUX4)	dly_mux_dut[2]	= mux_dut[2];
	assign	#(`T_DLY_MUX4)	dly_mux_dut[3]	= mux_dut[3];
	
	always @(*) begin
		case(i_sel_dut)
			0:	o_mux	= dly_mux_dut[0];
			1:	o_mux	= dly_mux_dut[1];
			2:	o_mux	= dly_mux_dut[2];
			3:	o_mux	= dly_mux_dut[3];
		endcase
	end

endmodule

