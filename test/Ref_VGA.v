module VGA_CTRL (
	input 				VGA_CLK, 
	input 				RST, 
	output  			PIXEL, 
	output  			VGA_HS, 
	output 	 			VGA_VS,
	output	[18:0]	    P_COUNT 
);

	wire	CLK = VGA_CLK;				 

	reg		[9:0]		next_H_COUNT;
	reg		[9:0]		next_V_COUNT;
	reg		[18:0]		next_P_COUNT;
	wire	[9:0]		H_COUNT;
	wire	[9:0]		V_COUNT;

	wire	H_MAX = (H_COUNT == 800 -1);
	wire	V_MAX = (V_COUNT == 525 -1);
	wire	P_MAX = (P_COUNT == 640*480 - 1);

	always @*
		begin
			casex({H_MAX, V_MAX})
				2'b00 : {next_H_COUNT, next_V_COUNT} <= {H_COUNT + 1'b1, V_COUNT};
				2'b01 : {next_H_COUNT, next_V_COUNT} <= {H_COUNT + 1'b1, V_COUNT};
				2'b10 : {next_H_COUNT, next_V_COUNT} <= {10'd0, V_COUNT + 1'b1};
				2'b11 : {next_H_COUNT, next_V_COUNT} <= {10'd0, 10'd0};
			endcase
		end

	always @*
		begin
			casex({PIXEL, P_MAX})
				2'b0x : next_P_COUNT <= P_COUNT;
				2'b10 : next_P_COUNT <= P_COUNT + 1;
				2'b11 : next_P_COUNT <= 0;
			endcase
		end

	REG #(10) REG_H_COUNT (
		.CLK	(CLK),
		.RST	(RST),
		.EN		(1'b1),
		.D 		(next_H_COUNT),
		.Q		(H_COUNT)
	);

	REG #(10) REG_V_COUNT (
		.CLK	(CLK),
		.RST	(RST),
		.EN		(1'b1),
		.D 		(next_V_COUNT),
		.Q		(V_COUNT)
	);

	REG #(19) REG_P_COUNT (
		.CLK	(CLK),
		.RST	(RST),
		.EN		(1'b1),
		.D 		(next_P_COUNT),
		.Q		(P_COUNT)
	);

	assign PIXEL = (H_COUNT < 640) && (V_COUNT < 480);
	assign VGA_HS = ~((H_COUNT >= 640+16) && (H_COUNT < 640+16+96));
	assign VGA_VS = ~((V_COUNT >= 480+10) && (V_COUNT < 480+10+2));

	endmodule

	module REG #(parameter N = 1)(
		input						CLK,
		input						RST,
		input						EN,
		input			[N-1:0]		D,
		output	reg		[N-1:0]		Q
	);
		always @(posedge CLK, posedge RST)
			if(RST)
				Q <= 0;
			else
				Q <= D;
endmodule