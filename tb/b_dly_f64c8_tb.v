// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: b_dly_f64c8_tb.v
//	* Description	: 
// ==================================================

// --------------------------------------------------
//	Define Global Variables
// --------------------------------------------------
`define	CLKFREQ		10		// Clock Freq. (Unit: MHz)
`define	SIMCYCLE	`NVEC	// Sim. Cycles
`define NVEC		512		// # of Test Vector

// --------------------------------------------------
//	Includes
// --------------------------------------------------

module b_dly_f64c8_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire			o_out;
	reg				i_in;
	reg		[8:0]	i_dly_sel;

	b_dly_f64c8
	u_b_dly_f64c8(
		.o_out		(o_out		),
		.i_in		(i_in		),
		.i_dly_sel	(i_dly_sel	)
	);

	always #(1000*500/`CLKFREQ)	i_in= ~i_in;
// --------------------------------------------------
//	Tasks
// --------------------------------------------------
	reg		[4*32-1:0]	taskState;
	integer				err	= 0;

	task init;
		begin
			taskState		= "Init";
			i_in				= 1;
			i_dly_sel			= 0;
		end
	endtask


// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		for (i=0; i<`SIMCYCLE; i++) begin
			i_dly_sel	= i;
			#(1000000/`CLKFREQ);
		end
		#(1000000/`CLKFREQ);
		$finish;
	end

	time		ref1;
	time		ref2;

	always	@(posedge i_in)	begin
		ref1	= $time;
	end

	always	@(posedge o_out)	begin
		ref2	= $time;
		$display("[%d]: %t", i_dly_sel, ref2-ref1);
	end

// --------------------------------------------------
//	Dump VCD
// --------------------------------------------------
	reg	[8*32-1:0]	vcd_file;
	initial begin
		if ($value$plusargs("vcd_file=%s", vcd_file)) begin
			$dumpfile(vcd_file);
			$dumpvars;
		end else begin
			$dumpfile("b_dly_f64c8_tb.vcd");
			$dumpvars;
		end
	end

endmodule
