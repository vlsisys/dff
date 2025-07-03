// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: u_dut.v
//	* Description	: 
// ==================================================

`define			T_DLY_MUX4		50

module u_dut
#(	
	parameter	T_SU0	= 40,
	parameter	T_SU1	= 40,
	parameter	T_HD0	= 20,
	parameter	T_HD1	= 20,
	parameter	T_CQ0	= 100,
	parameter	T_CQ1	= 100
)
(	
	output reg			o_mux,
	input				i_d,
	input				i_clk,
	input	[1:0]		i_sel
);

	wire		dut_q	[0:1] ;

	//	T_SU	: Setup Time
	//	T_HD	: Hold  Time
	//	T_CK2Q	: CLK-to-Q 
	dff #(.T_SU(T_SU0), .T_HD(T_HD0), .T_CQ(T_CQ0)) dut0(.o_q(dut_q[0]), .i_d(i_d), .i_clk(i_clk), .i_rstn(1'b1));
	dff #(.T_SU(T_SU1), .T_HD(T_HD1), .T_CQ(T_CQ1)) dut1(.o_q(dut_q[1]), .i_d(i_d), .i_clk(i_clk), .i_rstn(1'b1));

	wire		dly_d      ;
	wire		dly_clk    ;
	wire		dly_q[0:1] ;

	assign	#(`T_DLY_MUX4)	dly_d		= i_d;
	assign	#(`T_DLY_MUX4)	dly_clk		= i_clk;
	assign	#(`T_DLY_MUX4)	dly_q[0]	= dut_q[0];
	assign	#(`T_DLY_MUX4)	dly_q[1]	= dut_q[1];

	always @(*) begin
		case(i_sel)
			0:	o_mux	= dly_d;
			1:	o_mux	= dly_clk;
			2:	o_mux	= dly_q[0];
			3:	o_mux	= dly_q[1];
		endcase
	end

endmodule
