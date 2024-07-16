`timescale 1ns/10ps


module tb_spi_slave();


reg 		rst, clk;

initial 	begin
	rst = 0;
	clk = 0;
	
#10000	rst = 1;

end	


always  #5	clk = ~clk;


reg	[3:0]	cnt1;
always @(posedge clk or negedge rst)
begin
	if(!rst)	cnt1 <= 4'b0;
	else		cnt1 <= cnt1 + 1'b1;
end

reg	[7:0]	cnt2;
always @(posedge clk or negedge rst)
begin
	if(!rst)	cnt2 <= 8'b0;
	else		cnt2 <= (cnt1==4'd15) ? cnt2+1'b1 : cnt2;
end

wire	[7:0]	slave_idw = 8'h64;
wire	[7:0]	slave_idr = 8'h65;
wire	[7:0]	waddr1    = 8'h10;
wire	[7:0]	raddr1    = 8'h10;
wire	[7:0]	wdata1    = 8'h45;

wire	[7:0]	waddr2    = 8'h11;
wire	[7:0]	raddr2    = 8'h11;
wire	[7:0]	wdata2    = 8'h89;

reg		ss;
always @(posedge clk or negedge rst)
begin
	if(!rst)	ss <= 1'b1;
	else		ss <= ((cnt2==8'd10 ) && (cnt1==4'd0)) ? 1'b0 :
	                      ((cnt2==8'd34 ) && (cnt1==4'd8)) ? 1'b1 : 
	                      ((cnt2==8'd60 ) && (cnt1==4'd0)) ? 1'b0 :
	                      ((cnt2==8'd84 ) && (cnt1==4'd8)) ? 1'b1 :
	                      ((cnt2==8'd110) && (cnt1==4'd0)) ? 1'b0 :
	                      ((cnt2==8'd134) && (cnt1==4'd8)) ? 1'b1 :
	                      ((cnt2==8'd160) && (cnt1==4'd0)) ? 1'b0 :
	                      ((cnt2==8'd184) && (cnt1==4'd8)) ? 1'b1 : ss ;
end

reg		sck;
always @(posedge clk or negedge rst)
begin
	if(!rst)	sck <= 1'b0;
	else		sck <= (cnt2==8'd11) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd12) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd13) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd14) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd15) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd16) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd17) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd18) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd19) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd20) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd21) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd22) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd23) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd24) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd25) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd26) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd27) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd28) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd29) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd30) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd31) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd32) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd33) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd34) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                        
	                       (cnt2==8'd61) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd62) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd63) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd64) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd65) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd66) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd67) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd68) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd69) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd70) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd71) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd72) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd73) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd74) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd75) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd76) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd77) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd78) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd79) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd80) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd81) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd82) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd83) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd84) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :

	                       (cnt2==8'd111) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd112) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd113) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd114) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd115) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd116) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd117) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd118) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd119) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd120) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd121) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd122) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd123) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd124) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd125) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd126) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd127) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd128) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd129) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd130) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd131) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd132) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd133) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd134) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :

	                       (cnt2==8'd161) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd162) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd163) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd164) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd165) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd166) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd167) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd168) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd169) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd170) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd171) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd172) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd173) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd174) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd175) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd176) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd177) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd178) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd179) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd180) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd181) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd182) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd183) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) :
	                       (cnt2==8'd184) ? ((cnt1==4'd0) ? 1'b1 : (cnt1==4'd8) ? 1'b0 : sck) : sck ;
end


reg		mosi;
always @(posedge clk or negedge rst)
begin
	if(!rst)	mosi <= 1'b1;
	else		mosi <= ((cnt2==8'd10) && (cnt1==4'd0)) ? slave_idw[7] :
	                        ((cnt2==8'd11) && (cnt1==4'd8)) ? slave_idw[6] :
	                        ((cnt2==8'd12) && (cnt1==4'd8)) ? slave_idw[5] :
	                        ((cnt2==8'd13) && (cnt1==4'd8)) ? slave_idw[4] :
	                        ((cnt2==8'd14) && (cnt1==4'd8)) ? slave_idw[3] :
	                        ((cnt2==8'd15) && (cnt1==4'd8)) ? slave_idw[2] :
	                        ((cnt2==8'd16) && (cnt1==4'd8)) ? slave_idw[1] :
	                        ((cnt2==8'd17) && (cnt1==4'd8)) ? slave_idw[0] :
	                        ((cnt2==8'd18) && (cnt1==4'd8)) ? waddr1[7]    :
	                        ((cnt2==8'd19) && (cnt1==4'd8)) ? waddr1[6]    :
	                        ((cnt2==8'd20) && (cnt1==4'd8)) ? waddr1[5]    :
	                        ((cnt2==8'd21) && (cnt1==4'd8)) ? waddr1[4]    :
	                        ((cnt2==8'd22) && (cnt1==4'd8)) ? waddr1[3]    :
	                        ((cnt2==8'd23) && (cnt1==4'd8)) ? waddr1[2]    :
	                        ((cnt2==8'd24) && (cnt1==4'd8)) ? waddr1[1]    :
	                        ((cnt2==8'd25) && (cnt1==4'd8)) ? waddr1[0]    :
	                        ((cnt2==8'd26) && (cnt1==4'd8)) ? wdata1[7]    :
	                        ((cnt2==8'd27) && (cnt1==4'd8)) ? wdata1[6]    :
	                        ((cnt2==8'd28) && (cnt1==4'd8)) ? wdata1[5]    :
	                        ((cnt2==8'd29) && (cnt1==4'd8)) ? wdata1[4]    :
	                        ((cnt2==8'd30) && (cnt1==4'd8)) ? wdata1[3]    :
	                        ((cnt2==8'd31) && (cnt1==4'd8)) ? wdata1[2]    :
	                        ((cnt2==8'd32) && (cnt1==4'd8)) ? wdata1[1]    :
	                        ((cnt2==8'd33) && (cnt1==4'd8)) ? wdata1[0]    :
	                        ((cnt2==8'd35) && (cnt1==4'd0)) ? 1'b1         : 
	                        
	                        ((cnt2==8'd60) && (cnt1==4'd0)) ? slave_idw[7] :
	                        ((cnt2==8'd61) && (cnt1==4'd8)) ? slave_idw[6] :
	                        ((cnt2==8'd62) && (cnt1==4'd8)) ? slave_idw[5] :
	                        ((cnt2==8'd63) && (cnt1==4'd8)) ? slave_idw[4] :
	                        ((cnt2==8'd64) && (cnt1==4'd8)) ? slave_idw[3] :
	                        ((cnt2==8'd65) && (cnt1==4'd8)) ? slave_idw[2] :
	                        ((cnt2==8'd66) && (cnt1==4'd8)) ? slave_idw[1] :
	                        ((cnt2==8'd67) && (cnt1==4'd8)) ? slave_idw[0] :
	                        ((cnt2==8'd68) && (cnt1==4'd8)) ? waddr2[7]    :
	                        ((cnt2==8'd69) && (cnt1==4'd8)) ? waddr2[6]    :
	                        ((cnt2==8'd70) && (cnt1==4'd8)) ? waddr2[5]    :
	                        ((cnt2==8'd71) && (cnt1==4'd8)) ? waddr2[4]    :
	                        ((cnt2==8'd72) && (cnt1==4'd8)) ? waddr2[3]    :
	                        ((cnt2==8'd73) && (cnt1==4'd8)) ? waddr2[2]    :
	                        ((cnt2==8'd74) && (cnt1==4'd8)) ? waddr2[1]    :
	                        ((cnt2==8'd75) && (cnt1==4'd8)) ? waddr2[0]    :
	                        ((cnt2==8'd76) && (cnt1==4'd8)) ? wdata2[7]    :
	                        ((cnt2==8'd77) && (cnt1==4'd8)) ? wdata2[6]    :
	                        ((cnt2==8'd78) && (cnt1==4'd8)) ? wdata2[5]    :
	                        ((cnt2==8'd79) && (cnt1==4'd8)) ? wdata2[4]    :
	                        ((cnt2==8'd80) && (cnt1==4'd8)) ? wdata2[3]    :
	                        ((cnt2==8'd81) && (cnt1==4'd8)) ? wdata2[2]    :
	                        ((cnt2==8'd82) && (cnt1==4'd8)) ? wdata2[1]    :
	                        ((cnt2==8'd83) && (cnt1==4'd8)) ? wdata2[0]    :
	                        ((cnt2==8'd85) && (cnt1==4'd0)) ? 1'b1         :

	                        ((cnt2==8'd110) && (cnt1==4'd0)) ? slave_idr[7] :
	                        ((cnt2==8'd111) && (cnt1==4'd8)) ? slave_idr[6] :
	                        ((cnt2==8'd112) && (cnt1==4'd8)) ? slave_idr[5] :
	                        ((cnt2==8'd113) && (cnt1==4'd8)) ? slave_idr[4] :
	                        ((cnt2==8'd114) && (cnt1==4'd8)) ? slave_idr[3] :
	                        ((cnt2==8'd115) && (cnt1==4'd8)) ? slave_idr[2] :
	                        ((cnt2==8'd116) && (cnt1==4'd8)) ? slave_idr[1] :
	                        ((cnt2==8'd117) && (cnt1==4'd8)) ? slave_idr[0] :
	                        ((cnt2==8'd118) && (cnt1==4'd8)) ? raddr1[7]    :
	                        ((cnt2==8'd119) && (cnt1==4'd8)) ? raddr1[6]    :
	                        ((cnt2==8'd120) && (cnt1==4'd8)) ? raddr1[5]    :
	                        ((cnt2==8'd121) && (cnt1==4'd8)) ? raddr1[4]    :
	                        ((cnt2==8'd122) && (cnt1==4'd8)) ? raddr1[3]    :
	                        ((cnt2==8'd123) && (cnt1==4'd8)) ? raddr1[2]    :
	                        ((cnt2==8'd124) && (cnt1==4'd8)) ? raddr1[1]    :
	                        ((cnt2==8'd125) && (cnt1==4'd8)) ? raddr1[0]    :
	                        ((cnt2==8'd126) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd127) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd128) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd129) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd130) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd131) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd132) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd133) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd135) && (cnt1==4'd0)) ? 1'b1         :

	                        ((cnt2==8'd160) && (cnt1==4'd0)) ? slave_idr[7] :
	                        ((cnt2==8'd161) && (cnt1==4'd8)) ? slave_idr[6] :
	                        ((cnt2==8'd162) && (cnt1==4'd8)) ? slave_idr[5] :
	                        ((cnt2==8'd163) && (cnt1==4'd8)) ? slave_idr[4] :
	                        ((cnt2==8'd164) && (cnt1==4'd8)) ? slave_idr[3] :
	                        ((cnt2==8'd165) && (cnt1==4'd8)) ? slave_idr[2] :
	                        ((cnt2==8'd166) && (cnt1==4'd8)) ? slave_idr[1] :
	                        ((cnt2==8'd167) && (cnt1==4'd8)) ? slave_idr[0] :
	                        ((cnt2==8'd168) && (cnt1==4'd8)) ? raddr2[7]    :
	                        ((cnt2==8'd169) && (cnt1==4'd8)) ? raddr2[6]    :
	                        ((cnt2==8'd170) && (cnt1==4'd8)) ? raddr2[5]    :
	                        ((cnt2==8'd171) && (cnt1==4'd8)) ? raddr2[4]    :
	                        ((cnt2==8'd172) && (cnt1==4'd8)) ? raddr2[3]    :
	                        ((cnt2==8'd173) && (cnt1==4'd8)) ? raddr2[2]    :
	                        ((cnt2==8'd174) && (cnt1==4'd8)) ? raddr2[1]    :
	                        ((cnt2==8'd175) && (cnt1==4'd8)) ? raddr2[0]    :
	                        ((cnt2==8'd176) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd177) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd178) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd179) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd180) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd181) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd182) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd183) && (cnt1==4'd8)) ? 1'b0         :
	                        ((cnt2==8'd185) && (cnt1==4'd0)) ? 1'b1         : mosi ;
end
	
wire		miso;
reg	[7:0]	rdata1 ;
always @(posedge clk or negedge rst)
begin
	if(!rst)	rdata1 <= 8'b0;
	else		begin
		rdata1[7] <= ((cnt2==8'd127) && (cnt1==4'd0)) ? miso : rdata1[7];
		rdata1[6] <= ((cnt2==8'd128) && (cnt1==4'd0)) ? miso : rdata1[6];
		rdata1[5] <= ((cnt2==8'd129) && (cnt1==4'd0)) ? miso : rdata1[5];
		rdata1[4] <= ((cnt2==8'd130) && (cnt1==4'd0)) ? miso : rdata1[4];
		rdata1[3] <= ((cnt2==8'd131) && (cnt1==4'd0)) ? miso : rdata1[3];
		rdata1[2] <= ((cnt2==8'd132) && (cnt1==4'd0)) ? miso : rdata1[2];
		rdata1[1] <= ((cnt2==8'd133) && (cnt1==4'd0)) ? miso : rdata1[1];
		rdata1[0] <= ((cnt2==8'd134) && (cnt1==4'd0)) ? miso : rdata1[0];
	end
end

reg	[7:0]	rdata2 ;
always @(posedge clk or negedge rst)
begin
	if(!rst)	rdata2 <= 8'b0;
	else		begin
		rdata2[7] <= ((cnt2==8'd177) && (cnt1==4'd0)) ? miso : rdata2[7];
		rdata2[6] <= ((cnt2==8'd178) && (cnt1==4'd0)) ? miso : rdata2[6];
		rdata2[5] <= ((cnt2==8'd179) && (cnt1==4'd0)) ? miso : rdata2[5];
		rdata2[4] <= ((cnt2==8'd180) && (cnt1==4'd0)) ? miso : rdata2[4];
		rdata2[3] <= ((cnt2==8'd181) && (cnt1==4'd0)) ? miso : rdata2[3];
		rdata2[2] <= ((cnt2==8'd182) && (cnt1==4'd0)) ? miso : rdata2[2];
		rdata2[1] <= ((cnt2==8'd183) && (cnt1==4'd0)) ? miso : rdata2[1];
		rdata2[0] <= ((cnt2==8'd184) && (cnt1==4'd0)) ? miso : rdata2[0];
	end
end
		

spi_slave	spi_slave(
	.rst       (rst    ),
	.clk       (clk    ),
	.ss        (ss       ),
	.sck       (sck      ),
	.mosi      (mosi     ),
	.miso      (miso     )
);
 

endmodule
