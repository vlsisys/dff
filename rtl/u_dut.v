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
	output reg			o_mux,
	input				i_d,
	input				i_clk,
	input	[1:0]		i_sel
);

	wire		d;
	wire		clk;

	assign	#(`T_DLY_INV)	d	= i_d;
	assign	#(`T_DLY_INV)	clk	= i_clk;

	wire		q	[0:1] ;

	dff #(.T_SU(T_SU), .T_HD(T_HD), .T_CQ(T_CQ)) dut0(.o_q(q[0]), .i_d(d), .i_clk(clk), .i_rstn(1'b1));
	dff #(.T_SU(T_SU), .T_HD(T_HD), .T_CQ(T_CQ)) dut1(.o_q(q[1]), .i_d(d), .i_clk(clk), .i_rstn(1'b1));

	always @(*) begin
		case(i_sel)
			0:	o_mux	= #(`T_DLY_MUX4) d;
			1:	o_mux	= #(`T_DLY_MUX4) clk;
			2:	o_mux	= #(`T_DLY_MUX4) q[0];
			3:	o_mux	= #(`T_DLY_MUX4) q[1];
		endcase
	end

endmodule
