`include "top.v"
module tb_top;

reg clk, rstn;

always #5 clk = ~clk;

initial begin
    clk = 0;
end

initial begin
    rstn =0;
    #20
    rstn = 1;
end

    top dut(
        .clk    (clk),
        .rstn   (rstn)
    );

    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);
        #1000
        $finish;
    end

endmodule