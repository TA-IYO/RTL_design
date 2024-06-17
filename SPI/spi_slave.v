`timescale 1ns / 1ps

`define		rUSER_REG1		8'h10
`define     rUSER_REG2      8'h11
`define     rUSER_REG3      8'h12
`define     rUSER_REG4      8'h13

module spi_slave(
    rst     ,
    clk     ,
    ss      ,
    sck     ,
    mosi    ,
    miso    
);

input       rst     ;
input       clk     ;
input       ss      ;
input       sck     ;
input       mosi    ;
output      miso    ;

//////////////////// DEFINE STATE, FLAG

parameter   SLAVE_IDW   =  8'h64;
parameter   SLAVE_IDR   =  8'h65;

parameter       IDLE    =   3'd0;
parameter       SLAVEID =   3'd1;
parameter       WADDR   =   3'd2;
parameter       WDATA   =   3'd3;
parameter       RADDR   =   3'd4;
parameter       RDATA   =   3'd5;
parameter       DONE    =   3'd6;

reg     [2:0]   s_state;
wire            s_idle    =   (s_state == IDLE    ) ? 1'b1 : 1'b0;
wire            s_slaveid =   (s_state == SLAVEID ) ? 1'b1 : 1'b0;
wire            s_waddr   =   (s_state == WADDR   ) ? 1'b1 : 1'b0;
wire            s_wdata   =   (s_state == WDATA   ) ? 1'b1 : 1'b0;
wire            s_raddr   =   (s_state == RADDR   ) ? 1'b1 : 1'b0;
wire            s_rdata   =   (s_state == RDATA   ) ? 1'b1 : 1'b0;
wire            s_done    =   (s_state == DONE    ) ? 1'b1 : 1'b0;

//////////////////// EDGE DETECTION

reg         ss_1d, ss_2d;
wire        ss_pedge =  ss_1d & ~ss_2d;
wire        ss_nedge = ~ss_1d &  ss_2d;
always @(posedge clk or negedge rst)
    begin
        if(!rst)    begin
            ss_1d <= 1'b1;
            ss_2d <= 1'b1;
        end
        else    begin
            ss_1d <= ss;
            ss_2d <= ss_1d;
        end
    end

reg         sck_1d, sck_2d;
wire        sck_pedge =  sck_1d & ~sck_2d;
wire        sck_nedge = ~sck_1d &  sck_2d;
always @(posedge clk or negedge rst)
    begin
        if(!rst)    begin
            sck_1d <= 1'b0;
            sck_2d <= 1'b0;
        end
        else    begin
            sck_1d <= sck;
            sck_2d <= sck_1d;
        end
    end

reg         mosi_1d, mosi_2d;
always @(posedge clk or negedge rst)
    begin
        if(!rst)    begin
            mosi_1d <= 1'b0;
            mosi_2d <= 1'b0;
        end
        else    begin
            mosi_1d <= mosi;
            mosi_2d <= mosi_1d;
        end
    end    

//////////////////// GET SLAVE ID

reg     [3:0]   sid_sckn_cnt;
always @(posedge clk or negedge rst) 

begin
    if(!rst)    sid_sckn_cnt <= 4'b0;
    else        sid_sckn_cnt <= ~s_slaveid ? 4'b0 : sck_nedge ? (sid_sckn_cnt+1'b1) : sid_sckn_cnt;
end

reg     [7:0]   slave_id;
always @(posedge clk or negedge rst) 
begin
    if(!rst)    slave_id <= 8'b0;
    else    begin
            slave_id[7] <= s_idle ? 1'b0 : (s_slaveid & sck_pedge & (sid_sckn_cnt==4'd0)) ? mosi_2d : slave_id[7]; 
            slave_id[6] <= s_idle ? 1'b0 : (s_slaveid & sck_pedge & (sid_sckn_cnt==4'd1)) ? mosi_2d : slave_id[6]; 
            slave_id[5] <= s_idle ? 1'b0 : (s_slaveid & sck_pedge & (sid_sckn_cnt==4'd2)) ? mosi_2d : slave_id[5]; 
            slave_id[4] <= s_idle ? 1'b0 : (s_slaveid & sck_pedge & (sid_sckn_cnt==4'd3)) ? mosi_2d : slave_id[4]; 
            slave_id[3] <= s_idle ? 1'b0 : (s_slaveid & sck_pedge & (sid_sckn_cnt==4'd4)) ? mosi_2d : slave_id[3]; 
            slave_id[2] <= s_idle ? 1'b0 : (s_slaveid & sck_pedge & (sid_sckn_cnt==4'd5)) ? mosi_2d : slave_id[2]; 
            slave_id[1] <= s_idle ? 1'b0 : (s_slaveid & sck_pedge & (sid_sckn_cnt==4'd6)) ? mosi_2d : slave_id[1]; 
            slave_id[0] <= s_idle ? 1'b0 : (s_slaveid & sck_pedge & (sid_sckn_cnt==4'd7)) ? mosi_2d : slave_id[0]; 
    end    
end

//////////////////// GET WADDRESS

reg     [3:0]   wa_sckn_cnt;
always @(posedge clk or negedge rst) 
begin
    if(!rst)    wa_sckn_cnt <= 4'b0;
    else        wa_sckn_cnt <= ~s_waddr ? 4'b0 : sck_nedge ? (wa_sckn_cnt+1'b1) : wa_sckn_cnt;
end

reg     [7:0]   waddr;
always @(posedge clk or negedge rst) 
begin
    if(!rst)    waddr <= 8'b0;
    else    begin
            waddr[7] <= s_idle ? 1'b0 : (s_waddr & sck_pedge & (wa_sckn_cnt==4'd0)) ? mosi_2d : waddr[7]; 
            waddr[6] <= s_idle ? 1'b0 : (s_waddr & sck_pedge & (wa_sckn_cnt==4'd1)) ? mosi_2d : waddr[6]; 
            waddr[5] <= s_idle ? 1'b0 : (s_waddr & sck_pedge & (wa_sckn_cnt==4'd2)) ? mosi_2d : waddr[5]; 
            waddr[4] <= s_idle ? 1'b0 : (s_waddr & sck_pedge & (wa_sckn_cnt==4'd3)) ? mosi_2d : waddr[4]; 
            waddr[3] <= s_idle ? 1'b0 : (s_waddr & sck_pedge & (wa_sckn_cnt==4'd4)) ? mosi_2d : waddr[3]; 
            waddr[2] <= s_idle ? 1'b0 : (s_waddr & sck_pedge & (wa_sckn_cnt==4'd5)) ? mosi_2d : waddr[2]; 
            waddr[1] <= s_idle ? 1'b0 : (s_waddr & sck_pedge & (wa_sckn_cnt==4'd6)) ? mosi_2d : waddr[1]; 
            waddr[0] <= s_idle ? 1'b0 : (s_waddr & sck_pedge & (wa_sckn_cnt==4'd7)) ? mosi_2d : waddr[0]; 
    end    
end

//////////////////// GET WDATA

reg     [3:0]   wd_sckn_cnt;
always @(posedge clk or negedge rst) 
begin
    if(!rst)    wd_sckn_cnt <= 4'b0;
    else        wd_sckn_cnt <= ~s_wdata ? 4'b0 : sck_nedge ? (wd_sckn_cnt+1'b1) : wd_sckn_cnt;
end

reg     [7:0]   wdata;
always @(posedge clk or negedge rst) 
begin
    if(!rst)    wdata <= 8'b0;
    else    begin
            wdata[7] <= s_idle ? 1'b0 : (s_wdata & sck_pedge & (wd_sckn_cnt==4'd0)) ? mosi_2d : wdata[7]; 
            wdata[6] <= s_idle ? 1'b0 : (s_wdata & sck_pedge & (wd_sckn_cnt==4'd1)) ? mosi_2d : wdata[6]; 
            wdata[5] <= s_idle ? 1'b0 : (s_wdata & sck_pedge & (wd_sckn_cnt==4'd2)) ? mosi_2d : wdata[5]; 
            wdata[4] <= s_idle ? 1'b0 : (s_wdata & sck_pedge & (wd_sckn_cnt==4'd3)) ? mosi_2d : wdata[4]; 
            wdata[3] <= s_idle ? 1'b0 : (s_wdata & sck_pedge & (wd_sckn_cnt==4'd4)) ? mosi_2d : wdata[3]; 
            wdata[2] <= s_idle ? 1'b0 : (s_wdata & sck_pedge & (wd_sckn_cnt==4'd5)) ? mosi_2d : wdata[2]; 
            wdata[1] <= s_idle ? 1'b0 : (s_wdata & sck_pedge & (wd_sckn_cnt==4'd6)) ? mosi_2d : wdata[1]; 
            wdata[0] <= s_idle ? 1'b0 : (s_wdata & sck_pedge & (wd_sckn_cnt==4'd7)) ? mosi_2d : wdata[0]; 
    end    
end

//////////////////// GET RADDR

reg     [3:0]   ra_sckn_cnt;
always @(posedge clk or negedge rst) 
begin
    if(!rst)    ra_sckn_cnt <= 4'b0;
    else        ra_sckn_cnt <= ~s_raddr ? 4'b0 : sck_nedge ? (ra_sckn_cnt+1'b1) : ra_sckn_cnt;
end

reg     [7:0]   raddr;
always @(posedge clk or negedge rst) 
begin
    if(!rst)    raddr <= 8'b0;
    else    begin
            raddr[7] <= s_idle ? 1'b0 : (s_raddr & sck_pedge & (ra_sckn_cnt==4'd0)) ? mosi_2d : raddr[7]; 
            raddr[6] <= s_idle ? 1'b0 : (s_raddr & sck_pedge & (ra_sckn_cnt==4'd1)) ? mosi_2d : raddr[6]; 
            raddr[5] <= s_idle ? 1'b0 : (s_raddr & sck_pedge & (ra_sckn_cnt==4'd2)) ? mosi_2d : raddr[5]; 
            raddr[4] <= s_idle ? 1'b0 : (s_raddr & sck_pedge & (ra_sckn_cnt==4'd3)) ? mosi_2d : raddr[4]; 
            raddr[3] <= s_idle ? 1'b0 : (s_raddr & sck_pedge & (ra_sckn_cnt==4'd4)) ? mosi_2d : raddr[3]; 
            raddr[2] <= s_idle ? 1'b0 : (s_raddr & sck_pedge & (ra_sckn_cnt==4'd5)) ? mosi_2d : raddr[2]; 
            raddr[1] <= s_idle ? 1'b0 : (s_raddr & sck_pedge & (ra_sckn_cnt==4'd6)) ? mosi_2d : raddr[1]; 
            raddr[0] <= s_idle ? 1'b0 : (s_raddr & sck_pedge & (ra_sckn_cnt==4'd7)) ? mosi_2d : raddr[0]; 
    end    
end

//////////////////// GET RDATA

reg     [3:0]   rd_sckn_cnt;
always @(posedge clk or negedge rst) 
begin
    if(!rst)    rd_sckn_cnt <= 4'b0;
    else        rd_sckn_cnt <= ~s_rdata ? 4'b0 : sck_nedge ? (rd_sckn_cnt+1'b1) : rd_sckn_cnt;
end

reg     s_raddr_1d, s_raddr_2d;
wire    s_raddr_nedge = ~s_raddr_1d & s_raddr_2d;
always @(posedge clk or negedge rst)
begin
    if(!rst)    begin
        s_raddr_1d <= 1'b0;
        s_raddr_2d <= 1'b0;
    end
    else    begin
        s_raddr_1d <= s_raddr;
        s_raddr_2d <= s_raddr_1d;
    end
end    

reg             sck_nedge_1d;
always @(posedge clk or negedge rst)
begin
    if(!rst)    sck_nedge_1d <= 1'b0;
    else        sck_nedge_1d <= sck_nedge;
end    

reg             sck_pedge_1d;
always @(posedge clk or negedge rst)
begin
    if(!rst)    sck_pedge_1d <= 1'b0;
    else        sck_pedge_1d <= sck_pedge;
end    

reg     [7:0]   rdata;
reg             miso;
always @(posedge clk or negedge rst) 
begin
    if(!rst)    miso <= 1'b0;
    else        miso <= s_idle ? 1'b0 :
                        (sck_nedge_1d & (rd_sckn_cnt==5'd0 )) ? rdata[7] :
                        (sck_nedge_1d & (rd_sckn_cnt==5'd1 )) ? rdata[6] :
                        (sck_nedge_1d & (rd_sckn_cnt==5'd2 )) ? rdata[5] :
                        (sck_nedge_1d & (rd_sckn_cnt==5'd3 )) ? rdata[4] :
                        (sck_nedge_1d & (rd_sckn_cnt==5'd4 )) ? rdata[3] :
                        (sck_nedge_1d & (rd_sckn_cnt==5'd5 )) ? rdata[2] :
                        (sck_nedge_1d & (rd_sckn_cnt==5'd6 )) ? rdata[1] :
                        (sck_nedge_1d & (rd_sckn_cnt==5'd7 )) ? rdata[0] :  miso;
end

//////////////////// DONE COUNTER

reg     [1:0]   done_cnt;
always @(posedge clk or negedge rst) 
begin
    if(!rst)    done_cnt <= 2'b0;
    else        done_cnt <= ~s_done ? 2'b0 : done_cnt+1'b1;
end

//////////////////// STATE TRANSITION

always @(posedge clk or negedge rst) 
begin
    if(!rst)    begin
                s_state <= 3'h0;
    end
    else        begin
                s_state <=  (s_idle     &   ss_nedge            ) ? SLAVEID :
                            (s_slaveid  &   (sid_sckn_cnt==4'd8)) ? ((slave_id==SLAVE_IDW) ? WADDR : (slave_id==SLAVE_IDR) ? RADDR : IDLE) :
                            (s_waddr    &   (wa_sckn_cnt==4'd8 )) ? WDATA   :
                            (s_wdata    &   ss_pedge            ) ? DONE    :
                            (s_raddr    &   (ra_sckn_cnt==4'd8) ) ? RDATA   :
                            (s_rdata    &   ss_pedge            ) ? DONE    :
                            (s_done     &   (done_cnt==2'd3)    ) ? IDLE    :   s_state;
    end    
end

//////////////////// STORE WDATA to REGISTER

reg     [7:0]   user_reg1, user_reg2, user_reg3, user_reg4;
always @(posedge clk or negedge rst) 
begin
    if(!rst)    begin
                user_reg1 <= 8'b0;
                user_reg2 <= 8'b0;
                user_reg3 <= 8'b0;
                user_reg4 <= 8'b0;
    end
    else        begin
                user_reg1 <= (s_done & (waddr==`rUSER_REG1)) ? wdata : user_reg1;
                user_reg2 <= (s_done & (waddr==`rUSER_REG2)) ? wdata : user_reg2;
                user_reg3 <= (s_done & (waddr==`rUSER_REG3)) ? wdata : user_reg3;
                user_reg4 <= (s_done & (waddr==`rUSER_REG4)) ? wdata : user_reg4;
    end    
end

always @(posedge clk or negedge rst) 
begin
    if(!rst)    rdata <= 16'b0;
    else        rdata <= s_idle ? 16'b0 :
                        (s_raddr & sck_pedge_1d & (ra_sckn_cnt==4'd7) & (raddr == `rUSER_REG1)) ? user_reg1 :    
                        (s_raddr & sck_pedge_1d & (ra_sckn_cnt==4'd7) & (raddr == `rUSER_REG2)) ? user_reg2 :    
                        (s_raddr & sck_pedge_1d & (ra_sckn_cnt==4'd7) & (raddr == `rUSER_REG3)) ? user_reg3 :    
                        (s_raddr & sck_pedge_1d & (ra_sckn_cnt==4'd7) & (raddr == `rUSER_REG4)) ? user_reg4 :   rdata; 
end

endmodule