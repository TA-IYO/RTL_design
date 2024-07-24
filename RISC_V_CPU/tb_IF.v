`timescale 1ns/1ps
`include "IF.v"

module tb_IF;

    reg             clk;
    reg             rstn;
    reg             btaken;
    reg             jal;
    reg    [31:0]   imm_i;
    reg    [31:0]   imm_j;
    wire   [31:0]   jal_addr;
    wire   [31:0]   inst;

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

initial begin
    btaken = 0;
    jal = 0;
    imm_i = 32'h1;
    imm_j = 32'h2;
end

IF instuction_fetch(
    .i_clk              (clk),
    .i_rstn             (rstn),
    .i_btaken           (btaken),
    .i_jal              (jal),
    .i_imm_i            (imm_i),
    .i_imm_j            (imm_j),
    .o_jal_addr         (jal_addr),
    .o_inst             (inst)
);

initial begin
    $dumpfile("tb_IF.vcd");
    $dumpvars(0, tb_IF);
    #100
    $finish;
end

endmodule
