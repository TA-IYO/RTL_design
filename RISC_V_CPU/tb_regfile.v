`timescale 1ns / 1ps

module tb_regfile;

    // Inputs
    reg                 clk;
    reg                 we;
    reg     [4:0]       rs1, rs2, rd;
    reg     [31:0]      rd_data;
    wire    [31:0]      rs1_data, rs2_data;

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk     = 0;
        we      = 1;
        rs1     = 5'b10000;
        rs2     = 5'b00001;
        rd      = 5'b01010;
        rd_data = 32'h12345678;
        #10
        rs1     = 5'b01010;
        rs2     = 5'b00010;
        rd      = 5'b00111;
        rd_data = 32'hffffffff;
        #10
        we=0;
        rs1     = 5'b00000;
        rs2     = 5'b00111;
        rd      = 5'b10001;
        rd_data = 32'h11111111;
        #10
        we=1;
        rs1     = 5'b10001;
        rs2     = 5'b01010;
        rd      = 5'b01110;
        rd_data = 32'h22222222;
    end

    regfile dut (
        .clk        (clk),
        .we         (we),
        .rs1        (rs1), 
        .rs2        (rs2), 
        .rd         (rd),
        .rd_data    (rd_data),
        .rs1_data   (rs1_data), 
        .rs2_data   (rs2_data)
    );

    // Dump waveforms
    initial begin
        $dumpfile("tb_regfile.vcd");
        $dumpvars(0, tb_regfile);
        #100
        $finish;
    end

endmodule





module regfile (
    input   wire                clk,
    input   wire                we,
    input   wire    [4:0]       rs1, rs2, rd,
    input   wire    [31:0]      rd_data,
    output  reg     [31:0]      rs1_data, rs2_data
);
    reg [31:0]  x   [31:0];

    always @(posedge clk) begin
        if (we)
            case (rd[4:0])
                5'd0: ;
                5'd1:   x[1] <= rd_data;
                5'd2:   x[2] <= rd_data;
                5'd3:   x[3] <= rd_data;
                5'd4:   x[4] <= rd_data;
                5'd5:   x[5] <= rd_data;
                5'd6:   x[6] <= rd_data;
                5'd7:   x[7] <= rd_data;
                5'd8:   x[8] <= rd_data;
                5'd9:   x[9] <= rd_data;
                5'd10:  x[10] <= rd_data;
                5'd11:  x[11] <= rd_data;
                5'd12:  x[12] <= rd_data;
                5'd13:  x[13] <= rd_data;
                5'd14:  x[14] <= rd_data;
                5'd15:  x[15] <= rd_data;
                5'd16:  x[16] <= rd_data;
                5'd17:  x[17] <= rd_data;
                5'd18:  x[18] <= rd_data;
                5'd19:  x[19] <= rd_data;
                5'd20:  x[20] <= rd_data;
                5'd21:  x[21] <= rd_data;
                5'd22:  x[22] <= rd_data;
                5'd23:  x[23] <= rd_data;
                5'd24:  x[24] <= rd_data;
                5'd25:  x[25] <= rd_data;
                5'd26:  x[26] <= rd_data;
                5'd27:  x[27] <= rd_data;
                5'd28:  x[28] <= rd_data;
                5'd29:  x[29] <= rd_data;
                5'd30:  x[30] <= rd_data;
                5'd31:  x[31] <= rd_data;
            endcase
        end

    always @(*) begin
        case (rs1[4:0])
            5'd0:   rs1_data <= 32'h0;
            5'd1:   rs1_data <= x[1];
            5'd2:   rs1_data <= x[2];
            5'd3:   rs1_data <= x[3];
            5'd4:   rs1_data <= x[4];
            5'd5:   rs1_data <= x[5];
            5'd6:   rs1_data <= x[6];
            5'd7:   rs1_data <= x[7];
            5'd8:   rs1_data <= x[8];
            5'd9:   rs1_data <= x[9];
            5'd10:  rs1_data <= x[10];
            5'd11:  rs1_data <= x[11];
            5'd12:  rs1_data <= x[12];
            5'd13:  rs1_data <= x[13];
            5'd14:  rs1_data <= x[14];
            5'd15:  rs1_data <= x[15];
            5'd16:  rs1_data <= x[16];
            5'd17:  rs1_data <= x[17];
            5'd18:  rs1_data <= x[18];
            5'd19:  rs1_data <= x[19];
            5'd20:  rs1_data <= x[20];
            5'd21:  rs1_data <= x[21];
            5'd22:  rs1_data <= x[22];
            5'd23:  rs1_data <= x[23];
            5'd24:  rs1_data <= x[24];
            5'd25:  rs1_data <= x[25];
            5'd26:  rs1_data <= x[26];
            5'd27:  rs1_data <= x[27];
            5'd28:  rs1_data <= x[28];
            5'd29:  rs1_data <= x[29];
            5'd30:  rs1_data <= x[30];
            5'd31:  rs1_data <= x[31];
        endcase
    end

    always @(*) begin
        case (rs2[4:0])
            5'd0:   rs2_data <= 32'h0;
            5'd1:   rs2_data <= x[1];
            5'd2:   rs2_data <= x[2];
            5'd3:   rs2_data <= x[3];
            5'd4:   rs2_data <= x[4];
            5'd5:   rs2_data <= x[5];
            5'd6:   rs2_data <= x[6];
            5'd7:   rs2_data <= x[7];
            5'd8:   rs2_data <= x[8];
            5'd9:   rs2_data <= x[9];
            5'd10:  rs2_data <= x[10];
            5'd11:  rs2_data <= x[11];
            5'd12:  rs2_data <= x[12];
            5'd13:  rs2_data <= x[13];
            5'd14:  rs2_data <= x[14];
            5'd15:  rs2_data <= x[15];
            5'd16:  rs2_data <= x[16];
            5'd17:  rs2_data <= x[17];
            5'd18:  rs2_data <= x[18];
            5'd19:  rs2_data <= x[19];
            5'd20:  rs2_data <= x[20];
            5'd21:  rs2_data <= x[21];
            5'd22:  rs2_data <= x[22];
            5'd23:  rs2_data <= x[23];
            5'd24:  rs2_data <= x[24];
            5'd25:  rs2_data <= x[25];
            5'd26:  rs2_data <= x[26];
            5'd27:  rs2_data <= x[27];
            5'd28:  rs2_data <= x[28];
            5'd29:  rs2_data <= x[29];
            5'd30:  rs2_data <= x[30];
            5'd31:  rs2_data <= x[31];
        endcase
    end
endmodule