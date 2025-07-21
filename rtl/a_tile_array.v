// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: a_tile_array.v
//	* Description	: 
// ==================================================

module a_tile_array
(	
	output				o_tile,
	input				i_d,
	input				i_clk,
	input	[3:0]		i_addr,
	input				i_edge_sel,
	input	[1:0]		i_sigs_sel
);

	wire	[1:0]		duts_sel     ;
	wire	[1:0]		sigs_sel     ;
	wire				edge_sel     ;
	wire	[3:0]		tile_sel     ;
	wire				d            ;
	wire				clk          ;
	wire				tile_io[0:3] ;

	assign	#(`T_DLY_BUF)	duts_sel = i_addr[1:0]         ;
	assign	#(`T_DLY_BUF)	sigs_sel = i_sigs_sel          ;
	assign	#(`T_DLY_BUF)	edge_sel = i_edge_sel          ;
	assign	#(`T_DLY_DEC2)	tile_sel = 4'b1 << i_addr[3:2] ;
	assign	#(`T_DLY_BUF)	d        = i_d                 ;
	assign	#(`T_DLY_BUF)	clk      = i_clk               ;

	u_tile
	#(
		.T_SU0		(40				),
		.T_SU1		(50				),
		.T_SU2		(60				),
		.T_SU3		(70				),
		.T_HD0		(60				),
		.T_HD1		(80				),
		.T_HD2		(100			),
		.T_HD3		(120			),
		.T_CQ0		(140			),
		.T_CQ1		(240			),
		.T_CQ2		(340			),
		.T_CQ3		(440			)
	)
	u_tile0(
		.o_tile		(tile_io[0]		),
		.i_tile		(1'b0			),
		.i_d		(d				),
		.i_clk		(clk			),
		.i_edge_sel	(edge_sel		),
		.i_tile_sel	(tile_sel[0]	),
		.i_duts_sel	(duts_sel		),
		.i_sigs_sel	(sigs_sel		)
	);

	u_tile
	#(
		.T_SU0		(40				),
		.T_SU1		(50				),
		.T_SU2		(60				),
		.T_SU3		(70				),
		.T_HD0		(60				),
		.T_HD1		(80				),
		.T_HD2		(100			),
		.T_HD3		(120			),
		.T_CQ0		(140			),
		.T_CQ1		(240			),
		.T_CQ2		(340			),
		.T_CQ3		(440			)
	)
	u_tile1(
		.o_tile		(tile_io[1]		),
		.i_tile		(tile_io[0] 	),
		.i_d		(d				),
		.i_clk		(clk			),
		.i_edge_sel	(edge_sel		),
		.i_tile_sel	(tile_sel[1]	),
		.i_duts_sel	(duts_sel		),
		.i_sigs_sel	(sigs_sel		)
	);

	u_tile
	#(
		.T_SU0		(40				),
		.T_SU1		(50				),
		.T_SU2		(60				),
		.T_SU3		(70				),
		.T_HD0		(60				),
		.T_HD1		(80				),
		.T_HD2		(100			),
		.T_HD3		(120			),
		.T_CQ0		(140			),
		.T_CQ1		(240			),
		.T_CQ2		(340			),
		.T_CQ3		(440			)
	)
	u_tile2(
		.o_tile		(tile_io[2]		),
		.i_tile		(tile_io[1] 	),
		.i_d		(d				),
		.i_clk		(clk			),
		.i_edge_sel	(edge_sel		),
		.i_tile_sel	(tile_sel[2]	),
		.i_duts_sel	(duts_sel		),
		.i_sigs_sel	(sigs_sel		)
	);

	u_tile
	#(
		.T_SU0		(40				),
		.T_SU1		(50				),
		.T_SU2		(60				),
		.T_SU3		(70				),
		.T_HD0		(60				),
		.T_HD1		(80				),
		.T_HD2		(100			),
		.T_HD3		(120			),
		.T_CQ0		(140			),
		.T_CQ1		(240			),
		.T_CQ2		(340			),
		.T_CQ3		(440			)
	)
	u_tile3(
		.o_tile		(o_tile			),
		.i_tile		(tile_io[2] 	),
		.i_d		(d				),
		.i_clk		(clk			),
		.i_edge_sel	(edge_sel		),
		.i_tile_sel	(tile_sel[3]	),
		.i_duts_sel	(duts_sel		),
		.i_sigs_sel	(sigs_sel		)
	);

endmodule
