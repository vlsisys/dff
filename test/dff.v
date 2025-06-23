// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: dff.v
//	* Date			: 2024-06-24 14:43:33
//	* Description	: 
// ==================================================

module	dff
(	
	output reg			o_q,
	input				i_d,
	input				i_clk,
	input				i_rstn
);

	wire				d_dly;
	assign	#(2.5)		d_dly	= i_d;

	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			o_q	<= 0;
		end else begin
			o_q	<= d_dly;
		end
	end
	
endmodule
