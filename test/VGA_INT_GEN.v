module VGA_INT_GEN (
	input			CLK,
	input			RST,
	input			text_in,
	input	[7:0]	text,
	output		    vga_irq
);

localparam x = 2'b00;
localparam k = 2'b01;
localparam e = 2'b10;
localparam y = 2'b11;

reg [1:0]	cur_state;
reg [1:0]	nxt_state;

always @(posedge CLK, posedge RST)
	if(RST)
		cur_state <= 2'b00;
	else
		cur_state <= nxt_state;
		
always @(*)
	case({text_in, text, cur_state})
		{1'b1, 8'h4B, 2'b00} : nxt_state = 2'b01;
		{1'b1, 8'h45, 2'b01} : nxt_state = 2'b10;
		{1'b1, 8'h59, 2'b10} : nxt_state = 2'b11;
		default : nxt_state = 2'b00;
	endcase
	
assign vga_irq = (cur_state == 2'b11);



endmodule

