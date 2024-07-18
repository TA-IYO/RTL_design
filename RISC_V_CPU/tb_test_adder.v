`timescale 1ns/1ps
`include "EXE.v"
module tb_test_adder;

    reg             clk;
    reg             rstn;
    reg     [31:0]   a, b;
    reg             sub;
    wire    [31:0]   sum;
    wire            N, Z, C, V;

    kogge_adder test(
        .a(a),
        .b(b),
        .sub(sub),
        .sum(sum),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rstn = 0;
        #10;
        rstn = 1; 
    end

initial begin
    a = 32'h80000000; b = 32'h00000001; sub = 1'b0; #10; 
    a = 32'h00000001; b = 32'hFFFFFFFF; sub = 1'b0; #10; 
    a = 32'hFFFFFFFF; b = 32'h00000001; sub = 1'b0; #10; 
    a = 32'h7FFFFFFF; b = 32'h00000001; sub = 1'b0; #10; 

    // 추가 테스트 벡터
    a = 32'h55555555; b = 32'h44444444; sub = 1'b0; #10; 
    a = 32'h44444444; b = 32'h12345678; sub = 1'b0; #10; 
    a = 32'h44444444; b = 32'h11111111; sub = 1'b0; #10; 
    a = 32'h00000000; b = 32'h00000000; sub = 1'b0; #10; 
    
    // 뺄셈 테스트
    a = 32'h00000001; b = 32'h00000010; sub = 1'b1; #10; 
    a = 32'hFFFFFFFF; b = 32'h80000000; sub = 1'b1; #10; 
    a = 32'h78787878; b = 32'h34343434; sub = 1'b1; #10; 
    a = 32'h00000000; b = 32'h00000000; sub = 1'b1; #10; 
end


initial begin
    $dumpfile("tb_test_adder.vcd");
    $dumpvars(0, tb_test_adder);
    #150
    $finish;    
end

endmodule
