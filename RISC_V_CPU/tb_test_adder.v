module tb_test_adder;

    reg             clk;
    reg             rstn;
    reg     [7:0]   a,b;
    reg             sub;
    wire    [7:0]   sum;
    wire            N,Z,C,V;

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

test_adder(
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
    $dumpfile("tb_test_adder.vcd");
    $dumpvars(0, tb_test_adder);
    $dumpflush;
    #100
    $finish;
end

endmodule