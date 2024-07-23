`timescale 1ns / 1ps

module tb_ID;

    // Inputs
    reg clk;
    reg [31:0] inst;
    reg [4:0] i_rd;
    reg [31:0] i_rd_data;
    reg [31:0] i_pc;

    // Outputs
    wire [31:0] o_pc;
    wire [31:0] o_rs1_data;
    wire [31:0] o_rs2_data;
    wire [31:0] o_imm;
    wire [4:0] o_rd;

    // Instantiate the Unit Under Test (UUT)
    ID uut (
        .clk(clk),
        .inst(inst),
        .i_rd(i_rd),
        .i_rd_data(i_rd_data),
        .i_pc(i_pc),
        .o_pc(o_pc),
        .o_rs1_data(o_rs1_data),
        .o_rs2_data(o_rs2_data),
        .o_imm(o_imm),
        .o_rd(o_rd)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        inst = 0;
        i_rd = 0;
        i_rd_data = 0;
        i_pc = 0;

        // Wait for global reset
        #100;

        // Test case 1: R-type instruction (ADD)
        inst = {7'b0000000, 5'd1, 5'd2, 3'b000, 5'd3, `OP_R}; // add x3, x1, x2
        i_rd = 5'd3;
        i_rd_data = 32'd10;
        i_pc = 32'd100;
        #10;

        // Test case 2: I-type instruction (ADDI)
        inst = {12'd5, 5'd1, 3'b000, 5'd4, `OP_I}; // addi x4, x1, 5
        i_rd = 5'd4;
        i_rd_data = 32'd15;
        i_pc = 32'd104;
        #10;

        // Test case 3: I-type Load instruction (LW)
        inst = {12'd8, 5'd2, 3'b010, 5'd5, `OP_I_LOAD}; // lw x5, 8(x2)
        i_rd = 5'd5;
        i_rd_data = 32'd20;
        i_pc = 32'd108;
        #10;

        // Test case 4: S-type instruction (SW)
        inst = {7'd10, 5'd3, 5'd6, 3'b010, 5'd11, `OP_S}; // sw x6, 10(x3)
        i_rd = 5'd6;
        i_rd_data = 32'd25;
        i_pc = 32'd112;
        #10;

        // Test case 5: B-type instruction (BEQ)
        inst = {7'b0000000, 5'd7, 5'd8, 3'b000, 5'd9, `OP_B}; // beq x7, x8, 9
        i_rd = 5'd7;
        i_rd_data = 32'd30;
        i_pc = 32'd116;
        #10;

        // Test case 6: U-type instruction (LUI)
        inst = {20'd100, 5'd10, `OP_U_LUI}; // lui x10, 100
        i_rd = 5'd10;
        i_rd_data = 32'd35;
        i_pc = 32'd120;
        #10;

        // Test case 7: J-type instruction (JAL)
        inst = {20'd15, 5'd11, `OP_J_JAL}; // jal x11, 15
        i_rd = 5'd11;
        i_rd_data = 32'd40;
        i_pc = 32'd124;
        #10;
    end

    // Clock generation
    always #5 clk = ~clk;

    // Dump waveforms
    initial begin
        $dumpfile("tb_ID.vcd");
        $dumpvars(0, tb_ID);
        #150;
        $finish;
    end

endmodule
