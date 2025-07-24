// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: a_top.v
//	* Description	: 
// ==================================================

module a_top
(	
	output 				o_osc,
	output 				o_cff,
	input		[ 1:0]	i_mode,
	input		[ 4:0]	i_addr,
	input				i_osc_en,
	input				i_start,
	input				i_clk,
	input				i_rstn
);

	wire		[10:0]	dly_ref;
	wire		[ 8:0]	dly_dat;
	wire				edge_d;
	wire				edge_c;
	wire				edge_m;
	wire		[ 1:0]	sigs_sel;
	wire				cff_out;
	wire				d;
	wire				clk;
	wire				test_clk;
	wire				tile_out;
	wire				ref1;
	wire				ref2;

	assign				test_clk = ~i_clk;

	a_fsm
	u_a_fsm(
		.o_dly_ref		(dly_ref		),
		.o_dly_dat		(dly_dat		),
		.o_edge_d		(edge_d			),
		.o_edge_c		(edge_c			),
		.o_edge_m		(edge_m			),
		.o_sigs_sel		(sigs_sel		),
		.i_mode			(i_mode			),
		.i_addr			(i_addr			),
		.i_start		(i_start		),
		.i_cff_out		(o_cff			),
		.i_clk			(i_clk			),
		.i_rstn			(i_rstn			)
	);
	
	a_delay_dat
	u_a_delay_dat(
		.o_out			(d				),
		.i_in			(ref1			),
		.i_dly			(dly_dat		),
		.i_edge_d		(edge_d			)
	);

	a_delay_clk
	u_a_delay_clk(
		.o_out			(clk			),
		.i_in			(ref1			),
		.i_dly			(9'd256			),
		.i_edge_c		(edge_c			)
	);

	a_delay_ref
	u_a_delay_ref(
		.o_osc			(o_osc			),
		.o_ref1			(ref1			),
		.o_ref2			(ref2			),
		.i_dly			(dly_ref		),
		.i_test_clk		(test_clk		),
		.i_osc_en		(i_osc_en		)
	);

	a_tile_array
	u_a_tile_array(
		.o_tile			(tile_out		),
		.i_d			(d				),
		.i_clk			(clk			),
		.i_addr			(i_addr[4:1]	),
		.i_edge_sel		(edge_m			),
		.i_sigs_sel		(sigs_sel		)
	);

	dff
	#(
		.T_SU			(40				),
		.T_HD			(0				),
		.T_CQ			(200			)
	)
	cff(
		.o_q			(o_cff			),
		.i_d			(tile_out		),
		.i_clk			(ref2			),
		.i_rstn			(i_rstn			)
	);

endmodule
