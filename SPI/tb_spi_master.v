`timescale 1ns/1ps

module tb_spi_master();

reg rst, clk;

initial begin
        rst = 0;
        clk = 0;
#10000  rst = 1;
end

always #5   clk = ~clk;

reg     [14:0]  cnt;
always @(posedge clk or negedge rst) begin
    if(~rst)    cnt <= 15'b0;
    else        cnt <= cnt+1'b1;    
end

reg             start_w;
always @(posedge clk or negedge rst) begin
    if(~rst)    start_w <= 1'b0;
    else        start_w <= (cnt==15'd1000) ? 1'b1 : (cnt==15'd1010) ? 1'b0 : start_w;
end

reg             start_r;
always @(posedge clk or negedge rst) begin
    if(~rst)    start_r <= 1'b0;
    else        start_r <= (cnt==15'd6500) ? 1'b1 : (cnt==15'd6510) ? 1'b0 : start_r;
end

wire    [7:0]   rdata   ;
wire            done    ;
wire            ss      ;
wire            sck     ;
wire            mosi    ;
spi_master      spi_master_dut(
    .rst        (rst    ),    
    .clk        (clk    ),
    .freq       (freq   ),
    .start_w    (start_w),
    .start_r    (start_r),
    .addr       (addr   ),
    .wdata      (wdata  ),
    .rdata      (rdata  ),
    .done       (done   ),
    .ss         (ss     ),
    .sck        (sck    ),
    .mosi       (mosi   ),
    .miso       (1'b0   )
);

endmodule






)