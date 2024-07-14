module pc (
    input   wire            clk,
    input   wire            rstn,
    output  reg     [31:0]  pc
);
    always @(posedge clk, negedge rstn) begin
        if(~rstn)
            pc  <=  32'h0;
        else
            pc  <=  pc + 4;
    end
endmodule