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
	reg	[18:0]	p_count;
	
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
	

	assign  VGA_HS = (H_COUNT < (H_AREA + H_FRONT))    			?      	1 :
	                 (H_COUNT == (H_AREA + H_FRONT))   			?      	0 : 
					 (H_COUNT == (H_AREA + H_FRONT + H_SYNC))	?		1 : VGA_HS;   

	assign  VGA_VS = (V_COUNT < (V_AREA + V_FRONT))    			?      	1 :
                 (V_COUNT == (V_AREA + V_FRONT))   			?      	0 : 
				 (V_COUNT == (V_AREA + V_FRONT + V_SYNC))	?		1 : VGA_VS;   
	
	assign	P_COUNT = p_count;
	
	assign	PIXEL = ((H_COUNT > (H_AREA-1)) | ((V_COUNT > (V_AREA-1)))) ? 0: 1;
	
	always @(posedge CLK, posedge RST)
		if(RST)
			p_count <= 19'h0;
		else if(p_count == 'd307199)
			p_count <= 19'h0;
		else if(PIXEL)
			p_count <= p_count + 1'b1;

endmodule
