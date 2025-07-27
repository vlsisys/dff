// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: u_dut.v
//	* Description	: 
// ==================================================

module u_dut
#(	
	parameter	T_SU	= 40,
	parameter	T_HD	= 20,
	parameter	T_CQ	= 100
)
(	
	output 				o_mux,
	input				i_d,
	input				i_clk,
	input	[1:0]		i_sel
);

	wire		d;
	wire		clk;

	assign	#(`T_DLY_INV)	d	= ~i_d;
	assign	#(`T_DLY_INV)	clk	= ~i_clk;

	wire		q0;
	wire		q1;

	dff #(.T_SU(T_SU), .T_HD(T_HD), .T_CQ(T_CQ)) dut0(.o_q(q0), .i_d(d), .i_clk(clk), .i_rstn(1'b1));
	dff #(.T_SU(T_SU), .T_HD(T_HD), .T_CQ(T_CQ)) dut1(.o_q(q1), .i_d(d), .i_clk(clk), .i_rstn(1'b1));

	assign	#(`T_DLY_MUX4)	o_mux =	i_sel == 0 ? d   :
									i_sel == 1 ? clk :
									i_sel == 2 ? q0  : q1;

endmodule
