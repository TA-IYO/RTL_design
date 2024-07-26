// `include "VGA_CTRL.v"
module tb_VGA_CTRL;

    reg     VGA_CLK;
    reg     RST;    
    wire    PIXEL;  
    wire    VGA_HS; 
    wire    VGA_VS; 
    wire    [18:0] P_COUNT;

always #5 VGA_CLK = ~VGA_CLK;

initial begin
    VGA_CLK = 0;
end

initial begin
    RST = 5;
#10
    RST = 0;
end

VGA_CTRL dut(
    .VGA_CLK     (VGA_CLK),
    .RST         (RST),
    .PIXEL       (PIXEL),
    .VGA_HS      (VGA_HS),
    .VGA_VS      (VGA_VS),
    .P_COUNT     (P_COUNT) 
);

// initial begin
//     $dumpfile("tb_VGA_CTRL.vcd");
//     $dumpvars(0, tb_VGA_CTRL);
//     $dumpflush;
//     #10000
//     $finish;
// end

endmodule