// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: dff.v
//	* Date			: 2024-06-24 14:43:33
//	* Description	: 
// ==================================================

module	dff
#(	
	parameter	T_SU	= 40,
	parameter	T_HD	= 20,
	parameter	T_CQ	= 100 
)
(	
	output reg			o_q,
	input				i_d,
	input				i_clk,
	input				i_rstn
);

	wire				delayed_d;
	assign	#(T_SU)		delayed_d	= i_d;

	wire	   			delayed_clk;
	assign	#(T_HD)		delayed_clk	= i_clk;

	wire	   			clk2q;
	assign	#(T_CK2Q)	clk2q		= i_clk;

	reg					q_ideal;
	reg					q_su_tested;
	reg					q_hd_tested;

	always @(posedge i_clk) begin
		q_ideal		<= i_d;
	end

	always @(posedge i_clk) begin
		q_su_tested	<= delayed_d;
	end

	always @(posedge delayed_clk) begin
		q_hd_tested	<= i_d;
	end

	wire				i_clk_check;
	assign	#(1)		i_clk_check	= i_clk;
	reg					su_pass;
	always @(posedge i_clk_check) begin
		if(q_ideal != q_su_tested) begin
			$display("[%t] Setup Time Violation!", $time);
			su_pass <= 0;
		end else begin
			su_pass <= 1;
		end
	end


	wire				delayed_clk_check;
	assign	#(1)		delayed_clk_check	= delayed_clk;
	reg					hd_pass;
	always	@(posedge delayed_clk_check) begin
		if(q_ideal != q_hd_tested) begin
			$display("[%t] Hold  Time Violation!", $time);
			hd_pass <= 0;
		end else begin
			hd_pass <= 1;
		end
	end

	always @(posedge clk2q or i_rstn) begin
		if(!i_rstn) begin
			o_q		<= 0;
		end else begin
			if (!su_pass) begin
				o_q		<=	q_su_tested;
			end else if (!hd_pass) begin
				o_q		<=	q_hd_tested;
			end else begin
				o_q		<=	i_d;
			end
		end
	end
	
endmodule
