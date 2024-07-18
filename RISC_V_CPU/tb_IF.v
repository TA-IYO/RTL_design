`timescale 1ns/1ps
`include "IF.v"
module tb_IF;

    reg             clk;
    reg             rstn;
    wire   [31:0]   pc;

initial begin
    clk = 0;
    forever #5
    clk = ~clk;
end

initial begin
    rstn = 0;
#10
    rstn = 1;
end

IF instuction_fetch(
    .clk    (clk),
    .rstn   (rstn),
    .pc     (pc)
);

initial begin
    $dumpfile("tb_IF.vcd");
    $dumpvars(0, tb_IF);
    #100
    $finish;
end

endmodule
