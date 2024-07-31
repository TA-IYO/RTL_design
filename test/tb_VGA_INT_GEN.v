`timescale 1ns/10ps
`include "VGA_INT_GEN.v"

module tb_VGA_INT_GEN;

    reg    		clk;
    reg			rstn;
    reg			text_in;
    reg	[7:0]	text;
    wire		vga_irq;

initial begin
    clk = 0;
    forever #5
    clk = ~clk;
end

initial begin
    rstn = 1;
#10
    rstn = 0;
end

initial begin
    text_in = 1'b1;
    text = 8'hff;
    #30
    text = 8'h4b;
    #10
    text = 8'h45;
    #10
    text = 8'h59;
end

VGA_INT_GEN dut(
    .CLK        (clk),
    .RST        (rstn),
    .text_in    (text_in),
    .text       (text),
    .vga_irq    (vga_irq)
);

initial begin
    $dumpfile("tb_VGA_INT_GEN.vcd");
    $dumpvars(0, tb_VGA_INT_GEN);
    $dumpflush;
    #100
    $finish;
end

endmodule