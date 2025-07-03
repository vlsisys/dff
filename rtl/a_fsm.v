// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Woong Choi (woongchoi@sm.ac.kr)
//	* Filename		: a_fsm.v
//	* Description	: 
// ==================================================

module a_fsm
(	
	output reg			o_mode,
	output reg	[8:0]	o_ref_dly_sel,
	output reg	[7:0]	o_dat_dly_sel,
	output reg	[1:0]	o_mux_sel,
	input				i_clk,
	input				i_rstn
);

	
// --------------------------------------------------
//	FSM
//	- Q_INIT0
//		: delay(D)	= min
//		: D_INV		= On (0)
//	- Q_INIT1
//		: delay(D)	= min
//		: D_INV		= Off(1)
//
//	- Check LH Pass/Fail
//		: delay(D)	= min -> incr
//		: D_INV		= Off(1)	
//		: If (D_INV != Q) -> Stop
//	- Check HL Pass/Fail
//		: delay(D)	= min -> incr
//		: D_INV		= On (0)	
//		: If (D_INV != Q) -> Stop

//	- Setup Time (Q: 0 -> 1)
// --------------------------------------------------
	localparam	S_IDLE			= 3'd0;
	localparam	S_SU_Q_LH		= 3'd1;
	localparam	S_SU_Q_HL		= 3'd1;

	reg			[ 2:0]	p_state        ;
	reg			[ 2:0]	c_state        ;
	reg			[ 2:0]	n_state        ;
	reg			[ 7:0]	block_size     ;
	wire		[ 7:0]	block_size_mod ;
	reg			[10:0]	input_offset   ;
	reg			[ 9:0]	obytes_len     ;

	reg					block_last;
	always @(*) begin
		case (c_state)
			S_ABSB	,
			S_SQUZ	: block_last	= (cnt_block + 1) == block_size_mod/8 ? 1:0;
			default	: block_last	= 0;
		endcase
	end

	// State Register
	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			p_state	<= S_IDLE;
			c_state	<= S_IDLE;
		end else begin
			p_state	<= c_state;
			c_state	<= n_state;
		end
	end

	// Next State Logic
	always @(*) begin
		case(c_state)
			S_IDLE			: n_state	=	i_ibytes_valid								? S_ABSB		: S_IDLE;
			S_ABSB			: n_state	=	!block_last 								? S_ABSB		:
											block_size == rate							? S_ABSB_KECCAK : 
											input_offset + block_size < i_ibytes_len	? S_ABSB		: S_PADD_KECCAK;
			S_ABSB_KECCAK	: n_state	=	!keccak_ostate_valid						? S_ABSB_KECCAK	:
											input_offset < i_ibytes_len					? S_ABSB		: S_PADD_KECCAK;
			S_PADD_KECCAK	: n_state	=	!keccak_ostate_valid						? S_PADD_KECCAK	: S_SQUZ;
			S_SQUZ			: n_state	=	!block_last									? S_SQUZ		:
											obytes_len - block_size > 0					? S_SQUZ_KECCAK : S_DONE;
			S_SQUZ_KECCAK	: n_state	=	!keccak_ostate_valid						? S_SQUZ_KECCAK	: S_SQUZ;
			S_DONE			: n_state	=	S_IDLE;
		endcase
	end

	always @(posedge i_clk or negedge i_rstn) begin
		if (!i_rstn) begin
			cnt_block	<= 0;
		end else begin
			case (c_state)
				S_ABSB	: cnt_block <= p_state == S_ABSB ? cnt_block + 1 : cnt_block;
				S_SQUZ	: cnt_block <= cnt_block + 1;
				default	: cnt_block <= 0;
			endcase
		end
	end

	always @(posedge i_clk or negedge i_rstn) begin
		if (!i_rstn) begin
			obytes_len	<= 0;
		end else begin
			case (c_state)
				S_ABSB	: obytes_len <= obytes_len_init;
				S_SQUZ	: obytes_len <= block_last ? obytes_len - block_size : obytes_len;
				default	: obytes_len <= obytes_len;
			endcase
		end
	end

	always @(*) begin
		case (c_state)
			S_ABSB			: block_size = (i_ibytes_len - input_offset) > rate	? rate : i_ibytes_len - input_offset;
			S_ABSB_KECCAK	: block_size = 0;
			S_SQUZ			: block_size = (obytes_len > rate) 					? rate : obytes_len;
			S_IDLE			,
			S_DONE			: block_size = 0;
			default			: block_size = block_size;
		endcase
	end

	assign	block_size_mod	= |block_size[2:0] ? {block_size[7:3], 3'b0} + 8 : block_size;


	always @(posedge i_clk or negedge i_rstn) begin
		if (!i_rstn) begin
			input_offset	<= 0;
		end else begin
			case (c_state)
				S_ABSB		: input_offset	<= block_last ? input_offset + block_size : input_offset;
				S_DONE		: input_offset	<= 0;
				default		: input_offset	<= input_offset;
			endcase
		end
	end

	always @(*) begin
		case (c_state)
			S_ABSB		: o_ibytes_ready	= n_state == S_ABSB ? 1 : 0;
			default		: o_ibytes_ready	= 0;
		endcase
	end

	always @(*) begin
		case (c_state)
			S_DONE		: o_obytes_done		= 1;
			default		: o_obytes_done		= 0;
		endcase
	end




endmodule
