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

test_adder test(
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
    a = 8'hff; b = 8'h80; sub = 1'b0; #10
    a = 8'hab; b = 8'h12; sub = 1'b0; #10
    a = 8'h44; b = 8'h11; sub = 1'b0; #10
    a = 8'h00; b = 8'h00; sub = 1'b0; #10
    a = 8'h01; b = 8'h10; sub = 1'b1; #10
    a = 8'hff; b = 8'h80; sub = 1'b1; #10
    a = 8'h78; b = 8'h34; sub = 1'b1; #10
    a = 8'h00; b = 8'h00; sub = 1'b1; 
end



initial begin
    $dumpfile("tb_test_adder.vcd");
    $dumpvars(0, tb_test_adder);
    $dumpflush;
    #100
    $finish;
end

endmodule