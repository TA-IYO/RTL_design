module VGA_CTRL (
	input 					VGA_CLK, 
	input 					RST, 
	output  				PIXEL, 
	output  				VGA_HS, 
	output 	 				VGA_VS,
	output		[18:0]		P_COUNT 
);

	localparam	H_AREA	=640;
	localparam	H_FRONT	=16;
	localparam	H_SYNC	=96;
	localparam	H_BACK	=48;
	localparam	H_WHOLE	=800;

	localparam	V_AREA	=480;
	localparam	V_FRONT	=10;
	localparam	V_SYNC	=2;
	localparam	V_BACK	=33;
	localparam	V_WHOLE	=525;

	wire	CLK = VGA_CLK;				 

	reg	[9:0]		H_COUNT;
	reg	[9:0]		V_COUNT;

	always @(posedge CLK, posedge RST)
		if(RST)	begin
			H_COUNT <= 0;
		end
	    else if(H_COUNT == (H_WHOLE-1))
	        H_COUNT <= 0;
		else begin
			H_COUNT <= H_COUNT + 1;
	    end   

	always @(posedge CLK, posedge RST)
		if(RST)	
			V_COUNT <= 0;
		else if(V_COUNT == (V_WHOLE-1))
	        V_COUNT <= 0;
	    else if(H_COUNT == (H_WHOLE-1))
	        V_COUNT = V_COUNT + 1;   

	assign VGA_HS = ~((H_COUNT >= 640+16) && (H_COUNT < 640+16+96));
	assign VGA_VS = ~((V_COUNT >= 480+10) && (V_COUNT < 480+10+2));

	assign	PIXEL = ((H_COUNT > (H_AREA-1)) | ((V_COUNT > (V_AREA-1)))) ? 0: 1;

	assign P_COUNT = 640*V_COUNT + H_COUNT;

endmodule
