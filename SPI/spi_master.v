module spi_master(
    rst,
    clk,
    freq,
    start_w,
    start_r,
    addr,
    wdata,
    rdata,
    done,
    ss,
    sck,
    mosi,
    miso
);
input           rst     ;
input           clk     ;
input   [9:0]   freq    ;
input           start_w ;
input           start_r ;
input   [7:0]   addr    ;
input   [7:0]   wdata   ;
output  [7:0]   rdata   ;  
output          done    ;
output          ss      ;
output          sck     ;
output          mosi    ;
input           miso    ;


parameter SLAVE_IDW =  8'h64;
parameter SLAVE_IDR =  8'h65;

reg     [1:0]   m_state;
parameter       M_IDLE  =   2'd0;
parameter       M_READY =   2'd1;
parameter       M_SEND  =   2'd2;
parameter       M_DONE  =   2'd3;

wire            s_idle  =   (m_state == M_IDLE  ) ? 1'b1 : 1'b0;
wire            s_ready =   (m_state == M_READY ) ? 1'b1 : 1'b0;
wire            s_send  =   (m_state == M_SEND  ) ? 1'b1 : 1'b0;
wire            s_done  =   (m_state == M_DONE  ) ? 1'b1 : 1'b0;


reg             startw_1d, startw_2d;
wire            startw_pedge = startw_1d & ~startw_2d;
always @(posedge clk or negedge rst)
    begin
        if(~rst)    begin
            startw_1d <= 1'b0;
            startw_2d <= 1'b0;
        end
        else    begin
            startw_1d <= start_w;
            startw_2d <= start_1d;
        end
    end

reg             startr_1d, startr_2d;
wire            startr_pedge = startr_1d & ~startr_2d;
always @(posedge clk or negedge rst)
    begin
        if(~rst)    begin
            startr_1d <= 1'b0;
            startr_2d <= 1'b0;
        end
        else    begin
            startr_1d <= start_r;
            startr_2d <= startr_1d;
        end
    end

reg     rw_flag;
always @(posedge clk or negedge rst)
    begin
        if(~rst)    rw_flag <= 1'b0;
        else        rw_flag <= startw_pedge ? 1'b0 : startr_pedge ? 1'b1 : rw_flag;
    end

    