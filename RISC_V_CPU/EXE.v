module EXE (
    input   wire    [31:0]      i_pc,
    input   wire    [31:0]      i_rs1_data,
    input   wire    [31:0]      i_rs2_data,
    input   wire    [31:0]      i_imm,
    input   wire    [31:0]      i_wb_data,
    input   wire                i_alu_src,
    input   wire    [4:0]       i_alu_ctrl,
    output  wire    [31:0]      o_wb_data,
    output  wire    [31:0]      o_pc_branch,
    output  wire    [31:0]      o_rd_data,
    output  wire    [31:0]      o_data_addr,
    output  wire    [31:0]      o_data_wr
);
    wire    N, Z, C, V;
    wire    [31:0]   rs2_data;
    assign  rs2_data = i_alu_src ? i_imm : i_rs1_data;
    assign  o_pc_branch = i_pc + (i_imm << 1);
    assign o_wb_data = i_wb_data;

    alu arithmetic_logic (
        .a          (i_rs1_data),
        .b          (i_b),
        .alu_ctrl   (alu_ctrl),
        .result     (alu_result),
        .N(N), .Z(Z), .C(C), .V(V)
    );

endmodule

module alu (
    input   wire    [31:0]  a,
    input   wire    [31:0]  b,
    input   wire    [4:0]   alu_ctrl,
    output  reg     [31:0]  result,
    output  wire            N, Z, C, V
);
    wire    [31:0]  b2,sum;
    wire            slt, sltu;

    assign b2 = alu_ctrl[4]? ~b : b;

    assign slt = N ^ V; 
    assign sltu = ~C;  

    always @(*) begin
        case (alu_ctrl[3:0])
            4'b0000: result <= sum;
            4'b0001: result <= a & b;
            4'b0010: result <= a | b;
            4'b0011: result <= a ^ b;
            4'b0100: result <= a << b[4:0];    
            4'b0101: result <= a >> b[4:0];    
            4'b0110: result <= a >>> b[4:0];   
            4'b0111: result <= {31'b0, slt};
            4'b1000: result <= {31'b0, sltu};
            default: result <= 32'b0;
        endcase
    end

    kogge_adder adder_subtractor (.a(a), .b(b2), .sub(alu_ctrl[4]), .sum(sum), .N(N), .Z(Z), .C(C), .V(V));

endmodule

// module add_sub (
//     input   wire    [31:0]  a,    
//     input   wire    [31:0]  b,   
//     input   wire            cin,
//     output  wire    [31:0]  sum,
//     output  wire            N, Z, C, V   
// );
//     wire    [31:0]  cout;

//     adder_1bit bit31 (.a(a[31]), .b(b[31]), .cin(cout[30]), .sum(sum[31]), .cout(cout[31]));
//     adder_1bit bit30 (.a(a[30]), .b(b[30]), .cin(cout[29]), .sum(sum[30]), .cout(cout[30]));
//     adder_1bit bit29 (.a(a[29]), .b(b[29]), .cin(cout[28]), .sum(sum[29]), .cout(cout[29]));
//     adder_1bit bit28 (.a(a[28]), .b(b[28]), .cin(cout[27]), .sum(sum[28]), .cout(cout[28]));

//     adder_1bit bit27 (.a(a[27]), .b(b[27]), .cin(cout[26]), .sum(sum[27]), .cout(cout[27]));
//     adder_1bit bit26 (.a(a[26]), .b(b[26]), .cin(cout[25]), .sum(sum[26]), .cout(cout[26]));
//     adder_1bit bit25 (.a(a[25]), .b(b[25]), .cin(cout[24]), .sum(sum[25]), .cout(cout[25]));
//     adder_1bit bit24 (.a(a[24]), .b(b[24]), .cin(cout[23]), .sum(sum[24]), .cout(cout[24]));

//     adder_1bit bit23 (.a(a[23]), .b(b[23]), .cin(cout[22]), .sum(sum[23]), .cout(cout[23]));
//     adder_1bit bit22 (.a(a[22]), .b(b[22]), .cin(cout[21]), .sum(sum[22]), .cout(cout[22]));
//     adder_1bit bit21 (.a(a[21]), .b(b[21]), .cin(cout[20]), .sum(sum[21]), .cout(cout[21]));
//     adder_1bit bit20 (.a(a[20]), .b(b[20]), .cin(cout[19]), .sum(sum[20]), .cout(cout[20]));

//     adder_1bit bit19 (.a(a[19]), .b(b[19]), .cin(cout[18]), .sum(sum[19]), .cout(cout[19]));
//     adder_1bit bit18 (.a(a[18]), .b(b[18]), .cin(cout[17]), .sum(sum[18]), .cout(cout[18]));
//     adder_1bit bit17 (.a(a[17]), .b(b[17]), .cin(cout[16]), .sum(sum[17]), .cout(cout[17]));
//     adder_1bit bit16 (.a(a[16]), .b(b[16]), .cin(cout[15]), .sum(sum[16]), .cout(cout[16]));

//     adder_1bit bit15 (.a(a[15]), .b(b[15]), .cin(cout[14]), .sum(sum[15]), .cout(cout[15]));
//     adder_1bit bit14 (.a(a[14]), .b(b[14]), .cin(cout[13]), .sum(sum[14]), .cout(cout[14]));
//     adder_1bit bit13 (.a(a[13]), .b(b[13]), .cin(cout[12]), .sum(sum[13]), .cout(cout[13]));
//     adder_1bit bit12 (.a(a[12]), .b(b[12]), .cin(cout[11]), .sum(sum[12]), .cout(cout[12]));

//     adder_1bit bit11 (.a(a[11]), .b(b[11]), .cin(cout[10]), .sum(sum[11]), .cout(cout[11]));
//     adder_1bit bit10 (.a(a[10]), .b(b[10]), .cin(cout[9]), .sum(sum[10]), .cout(cout[10]));
//     adder_1bit bit09 (.a(a[9]), .b(b[9]), .cin(cout[8]), .sum(sum[9]), .cout(cout[9]));
//     adder_1bit bit08 (.a(a[8]), .b(b[8]), .cin(cout[7]), .sum(sum[8]), .cout(cout[8]));

//     adder_1bit bit07 (.a(a[7]), .b(b[7]), .cin(cout[6]), .sum(sum[7]), .cout(cout[7]));
//     adder_1bit bit06 (.a(a[6]), .b(b[6]), .cin(cout[5]), .sum(sum[6]), .cout(cout[6]));
//     adder_1bit bit05 (.a(a[5]), .b(b[5]), .cin(cout[4]), .sum(sum[5]), .cout(cout[5]));
//     adder_1bit bit04 (.a(a[4]), .b(b[4]), .cin(cout[3]), .sum(sum[4]), .cout(cout[4]));

//     adder_1bit bit03 (.a(a[3]), .b(b[3]), .cin(cout[2]), .sum(sum[3]), .cout(cout[3]));
//     adder_1bit bit02 (.a(a[2]), .b(b[2]), .cin(cout[1]), .sum(sum[2]), .cout(cout[2]));
//     adder_1bit bit01 (.a(a[1]), .b(b[1]), .cin(cout[0]), .sum(sum[1]), .cout(cout[1]));
//     adder_1bit bit00 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(cout[0]));

//     assign N = sum[31];
//     assign Z = ~(|sum); //(sum == 32'b0);
//     assign C = cout[31];
//     assign V = cout[31] ^ cout[30];

// endmodule

// module adder_1bit(
//     input   wire    a,
//     input   wire    b,
//     input   wire    cin,
//     output  wire    sum,
//     output  wire    cout
// );
//     assign sum = a ^ b ^ cin;
//     assign cout = (a & b) | (a & cin) | (b & cin);
// endmodule

module kogge_adder (
    input       wire    [31:0]      a,
    input       wire    [31:0]      b,
    input       wire                sub,
    output      wire    [31:0]      sum,
    output      wire                N,   // Negative flag
    output      wire                Z,   // Zero flag
    output      wire                C,   // Carry flag
    output      wire                V    // Overflow flag
);

    wire [31:0] b_eff;       // Effective B (B or ~B)
    wire [31:0] p, g;        // Generate and Propagate
    wire [31:0] c;           // Carry bits

    // Effective B calculation based on Sub signal
    assign b_eff = sub? ~b : b;  // XOR with Sub to get B or ~B

    // Generate and Propagate
    // Stage 0
    assign g = a & b_eff;   // Generate
    assign p = a ^ b_eff;   // Propagate

    // Combine multiple stages for Kogge-Stone logic
    wire    [31:0]  g1, p1, g2, p2, g3, p3, g4, p4, g5, p5;

    // Stage 1
    assign {g1[0], p1[0]} = {g[0], p[0]};
    gp s1_01(.g_cur(g[ 1]),    .p_cur(p[ 1]),    .g_pre(g[ 0]),    .p_pre(p[ 0]),    .g_out(g1[ 1]),    .p_out(p1[ 1]));
    gp s1_02(.g_cur(g[ 2]),    .p_cur(p[ 2]),    .g_pre(g[ 1]),    .p_pre(p[ 1]),    .g_out(g1[ 2]),    .p_out(p1[ 2]));
    gp s1_03(.g_cur(g[ 3]),    .p_cur(p[ 3]),    .g_pre(g[ 2]),    .p_pre(p[ 2]),    .g_out(g1[ 3]),    .p_out(p1[ 3]));
    gp s1_04(.g_cur(g[ 4]),    .p_cur(p[ 4]),    .g_pre(g[ 3]),    .p_pre(p[ 3]),    .g_out(g1[ 4]),    .p_out(p1[ 4]));
    gp s1_05(.g_cur(g[ 5]),    .p_cur(p[ 5]),    .g_pre(g[ 4]),    .p_pre(p[ 4]),    .g_out(g1[ 5]),    .p_out(p1[ 5]));
    gp s1_06(.g_cur(g[ 6]),    .p_cur(p[ 6]),    .g_pre(g[ 5]),    .p_pre(p[ 5]),    .g_out(g1[ 6]),    .p_out(p1[ 6]));
    gp s1_07(.g_cur(g[ 7]),    .p_cur(p[ 7]),    .g_pre(g[ 6]),    .p_pre(p[ 6]),    .g_out(g1[ 7]),    .p_out(p1[ 7]));
    gp s1_08(.g_cur(g[ 8]),    .p_cur(p[ 8]),    .g_pre(g[ 7]),    .p_pre(p[ 7]),    .g_out(g1[ 8]),    .p_out(p1[ 8]));
    gp s1_09(.g_cur(g[ 9]),    .p_cur(p[ 9]),    .g_pre(g[ 8]),    .p_pre(p[ 8]),    .g_out(g1[ 9]),    .p_out(p1[ 9]));
    gp s1_10(.g_cur(g[10]),    .p_cur(p[10]),    .g_pre(g[ 9]),    .p_pre(p[ 9]),    .g_out(g1[10]),    .p_out(p1[10]));
    gp s1_11(.g_cur(g[11]),    .p_cur(p[11]),    .g_pre(g[10]),    .p_pre(p[10]),    .g_out(g1[11]),    .p_out(p1[11]));
    gp s1_12(.g_cur(g[12]),    .p_cur(p[12]),    .g_pre(g[11]),    .p_pre(p[11]),    .g_out(g1[12]),    .p_out(p1[12]));
    gp s1_13(.g_cur(g[13]),    .p_cur(p[13]),    .g_pre(g[12]),    .p_pre(p[12]),    .g_out(g1[13]),    .p_out(p1[13]));
    gp s1_14(.g_cur(g[14]),    .p_cur(p[14]),    .g_pre(g[13]),    .p_pre(p[13]),    .g_out(g1[14]),    .p_out(p1[14]));
    gp s1_15(.g_cur(g[15]),    .p_cur(p[15]),    .g_pre(g[14]),    .p_pre(p[14]),    .g_out(g1[15]),    .p_out(p1[15]));
    gp s1_16(.g_cur(g[16]),    .p_cur(p[16]),    .g_pre(g[15]),    .p_pre(p[15]),    .g_out(g1[16]),    .p_out(p1[16]));
    gp s1_17(.g_cur(g[17]),    .p_cur(p[17]),    .g_pre(g[16]),    .p_pre(p[16]),    .g_out(g1[17]),    .p_out(p1[17]));
    gp s1_18(.g_cur(g[18]),    .p_cur(p[18]),    .g_pre(g[17]),    .p_pre(p[17]),    .g_out(g1[18]),    .p_out(p1[18]));
    gp s1_19(.g_cur(g[19]),    .p_cur(p[19]),    .g_pre(g[18]),    .p_pre(p[18]),    .g_out(g1[19]),    .p_out(p1[19]));
    gp s1_20(.g_cur(g[20]),    .p_cur(p[20]),    .g_pre(g[19]),    .p_pre(p[19]),    .g_out(g1[20]),    .p_out(p1[20]));
    gp s1_21(.g_cur(g[21]),    .p_cur(p[21]),    .g_pre(g[20]),    .p_pre(p[20]),    .g_out(g1[21]),    .p_out(p1[21]));
    gp s1_22(.g_cur(g[22]),    .p_cur(p[22]),    .g_pre(g[21]),    .p_pre(p[21]),    .g_out(g1[22]),    .p_out(p1[22]));
    gp s1_23(.g_cur(g[23]),    .p_cur(p[23]),    .g_pre(g[22]),    .p_pre(p[22]),    .g_out(g1[23]),    .p_out(p1[23]));
    gp s1_24(.g_cur(g[24]),    .p_cur(p[24]),    .g_pre(g[23]),    .p_pre(p[23]),    .g_out(g1[24]),    .p_out(p1[24]));
    gp s1_25(.g_cur(g[25]),    .p_cur(p[25]),    .g_pre(g[24]),    .p_pre(p[24]),    .g_out(g1[25]),    .p_out(p1[25]));
    gp s1_26(.g_cur(g[26]),    .p_cur(p[26]),    .g_pre(g[25]),    .p_pre(p[25]),    .g_out(g1[26]),    .p_out(p1[26]));
    gp s1_27(.g_cur(g[27]),    .p_cur(p[27]),    .g_pre(g[26]),    .p_pre(p[26]),    .g_out(g1[27]),    .p_out(p1[27]));
    gp s1_28(.g_cur(g[28]),    .p_cur(p[28]),    .g_pre(g[27]),    .p_pre(p[27]),    .g_out(g1[28]),    .p_out(p1[28]));
    gp s1_29(.g_cur(g[29]),    .p_cur(p[29]),    .g_pre(g[28]),    .p_pre(p[28]),    .g_out(g1[29]),    .p_out(p1[29]));
    gp s1_30(.g_cur(g[30]),    .p_cur(p[30]),    .g_pre(g[29]),    .p_pre(p[29]),    .g_out(g1[30]),    .p_out(p1[30]));
    gp s1_31(.g_cur(g[31]),    .p_cur(p[31]),    .g_pre(g[30]),    .p_pre(p[30]),    .g_out(g1[31]),    .p_out(p1[31]));

    // Stage 2
    assign {g2[0], p2[0]} = {g1[0], p1[0]};
    assign {g2[1], p2[1]} = {g1[1], p1[1]};
    gp s2_01(.g_cur(g1[ 2]),    .p_cur(p1[ 2]),    .g_pre(g1[ 0]),    .p_pre(p1[ 0]),    .g_out(g2[ 2]),    .p_out(p2[ 2]));
    gp s2_02(.g_cur(g1[ 3]),    .p_cur(p1[ 3]),    .g_pre(g1[ 1]),    .p_pre(p1[ 1]),    .g_out(g2[ 3]),    .p_out(p2[ 3]));
    gp s2_03(.g_cur(g1[ 4]),    .p_cur(p1[ 4]),    .g_pre(g1[ 2]),    .p_pre(p1[ 2]),    .g_out(g2[ 4]),    .p_out(p2[ 4]));
    gp s2_04(.g_cur(g1[ 5]),    .p_cur(p1[ 5]),    .g_pre(g1[ 3]),    .p_pre(p1[ 3]),    .g_out(g2[ 5]),    .p_out(p2[ 5]));
    gp s2_05(.g_cur(g1[ 6]),    .p_cur(p1[ 6]),    .g_pre(g1[ 4]),    .p_pre(p1[ 4]),    .g_out(g2[ 6]),    .p_out(p2[ 6]));
    gp s2_06(.g_cur(g1[ 7]),    .p_cur(p1[ 7]),    .g_pre(g1[ 5]),    .p_pre(p1[ 5]),    .g_out(g2[ 7]),    .p_out(p2[ 7]));
    gp s2_07(.g_cur(g1[ 8]),    .p_cur(p1[ 8]),    .g_pre(g1[ 6]),    .p_pre(p1[ 6]),    .g_out(g2[ 8]),    .p_out(p2[ 8]));
    gp s2_08(.g_cur(g1[ 9]),    .p_cur(p1[ 9]),    .g_pre(g1[ 7]),    .p_pre(p1[ 7]),    .g_out(g2[ 9]),    .p_out(p2[ 9]));
    gp s2_09(.g_cur(g1[10]),    .p_cur(p1[10]),    .g_pre(g1[ 8]),    .p_pre(p1[ 8]),    .g_out(g2[10]),    .p_out(p2[10]));
    gp s2_10(.g_cur(g1[11]),    .p_cur(p1[11]),    .g_pre(g1[ 9]),    .p_pre(p1[ 9]),    .g_out(g2[11]),    .p_out(p2[11]));
    gp s2_11(.g_cur(g1[12]),    .p_cur(p1[12]),    .g_pre(g1[10]),    .p_pre(p1[10]),    .g_out(g2[12]),    .p_out(p2[12]));
    gp s2_12(.g_cur(g1[13]),    .p_cur(p1[13]),    .g_pre(g1[11]),    .p_pre(p1[11]),    .g_out(g2[13]),    .p_out(p2[13]));
    gp s2_13(.g_cur(g1[14]),    .p_cur(p1[14]),    .g_pre(g1[12]),    .p_pre(p1[12]),    .g_out(g2[14]),    .p_out(p2[14]));
    gp s2_14(.g_cur(g1[15]),    .p_cur(p1[15]),    .g_pre(g1[13]),    .p_pre(p1[13]),    .g_out(g2[15]),    .p_out(p2[15]));
    gp s2_15(.g_cur(g1[16]),    .p_cur(p1[16]),    .g_pre(g1[14]),    .p_pre(p1[14]),    .g_out(g2[16]),    .p_out(p2[16]));
    gp s2_16(.g_cur(g1[17]),    .p_cur(p1[17]),    .g_pre(g1[15]),    .p_pre(p1[15]),    .g_out(g2[17]),    .p_out(p2[17]));
    gp s2_17(.g_cur(g1[18]),    .p_cur(p1[18]),    .g_pre(g1[16]),    .p_pre(p1[16]),    .g_out(g2[18]),    .p_out(p2[18]));
    gp s2_18(.g_cur(g1[19]),    .p_cur(p1[19]),    .g_pre(g1[17]),    .p_pre(p1[17]),    .g_out(g2[19]),    .p_out(p2[19]));
    gp s2_19(.g_cur(g1[20]),    .p_cur(p1[20]),    .g_pre(g1[18]),    .p_pre(p1[18]),    .g_out(g2[20]),    .p_out(p2[20]));
    gp s2_20(.g_cur(g1[21]),    .p_cur(p1[21]),    .g_pre(g1[19]),    .p_pre(p1[19]),    .g_out(g2[21]),    .p_out(p2[21]));
    gp s2_21(.g_cur(g1[22]),    .p_cur(p1[22]),    .g_pre(g1[20]),    .p_pre(p1[20]),    .g_out(g2[22]),    .p_out(p2[22]));
    gp s2_22(.g_cur(g1[23]),    .p_cur(p1[23]),    .g_pre(g1[21]),    .p_pre(p1[21]),    .g_out(g2[23]),    .p_out(p2[23]));
    gp s2_23(.g_cur(g1[24]),    .p_cur(p1[24]),    .g_pre(g1[22]),    .p_pre(p1[22]),    .g_out(g2[24]),    .p_out(p2[24]));
    gp s2_24(.g_cur(g1[25]),    .p_cur(p1[25]),    .g_pre(g1[23]),    .p_pre(p1[23]),    .g_out(g2[25]),    .p_out(p2[25]));
    gp s2_25(.g_cur(g1[26]),    .p_cur(p1[26]),    .g_pre(g1[24]),    .p_pre(p1[24]),    .g_out(g2[26]),    .p_out(p2[26]));
    gp s2_26(.g_cur(g1[27]),    .p_cur(p1[27]),    .g_pre(g1[25]),    .p_pre(p1[25]),    .g_out(g2[27]),    .p_out(p2[27]));
    gp s2_27(.g_cur(g1[28]),    .p_cur(p1[28]),    .g_pre(g1[26]),    .p_pre(p1[26]),    .g_out(g2[28]),    .p_out(p2[28]));
    gp s2_28(.g_cur(g1[29]),    .p_cur(p1[29]),    .g_pre(g1[27]),    .p_pre(p1[27]),    .g_out(g2[29]),    .p_out(p2[29]));
    gp s2_29(.g_cur(g1[30]),    .p_cur(p1[30]),    .g_pre(g1[28]),    .p_pre(p1[28]),    .g_out(g2[30]),    .p_out(p2[30]));
    gp s2_30(.g_cur(g1[31]),    .p_cur(p1[31]),    .g_pre(g1[29]),    .p_pre(p1[29]),    .g_out(g2[31]),    .p_out(p2[31]));

    // Stage 3
    assign {g3[0], p3[0]} = {g2[0], p2[0]};
    assign {g3[1], p3[1]} = {g2[1], p2[1]};
    assign {g3[2], p3[2]} = {g2[2], p2[2]};
    assign {g3[3], p3[3]} = {g2[3], p2[3]};
    gp s3_01(.g_cur(g2[ 4]),    .p_cur(p2[ 4]),    .g_pre(g2[ 0]),    .p_pre(p2[ 0]),    .g_out(g3[ 4]),    .p_out(p3[ 4]));
    gp s3_02(.g_cur(g2[ 5]),    .p_cur(p2[ 5]),    .g_pre(g2[ 1]),    .p_pre(p2[ 1]),    .g_out(g3[ 5]),    .p_out(p3[ 5]));
    gp s3_03(.g_cur(g2[ 6]),    .p_cur(p2[ 6]),    .g_pre(g2[ 2]),    .p_pre(p2[ 2]),    .g_out(g3[ 6]),    .p_out(p3[ 6]));
    gp s3_04(.g_cur(g2[ 7]),    .p_cur(p2[ 7]),    .g_pre(g2[ 3]),    .p_pre(p2[ 3]),    .g_out(g3[ 7]),    .p_out(p3[ 7]));
    gp s3_05(.g_cur(g2[ 8]),    .p_cur(p2[ 8]),    .g_pre(g2[ 4]),    .p_pre(p2[ 4]),    .g_out(g3[ 8]),    .p_out(p3[ 8]));
    gp s3_06(.g_cur(g2[ 9]),    .p_cur(p2[ 9]),    .g_pre(g2[ 5]),    .p_pre(p2[ 5]),    .g_out(g3[ 9]),    .p_out(p3[ 9]));
    gp s3_07(.g_cur(g2[10]),    .p_cur(p2[10]),    .g_pre(g2[ 6]),    .p_pre(p2[ 6]),    .g_out(g3[10]),    .p_out(p3[10]));
    gp s3_08(.g_cur(g2[11]),    .p_cur(p2[11]),    .g_pre(g2[ 7]),    .p_pre(p2[ 7]),    .g_out(g3[11]),    .p_out(p3[11]));
    gp s3_09(.g_cur(g2[12]),    .p_cur(p2[12]),    .g_pre(g2[ 8]),    .p_pre(p2[ 8]),    .g_out(g3[12]),    .p_out(p3[12]));
    gp s3_10(.g_cur(g2[13]),    .p_cur(p2[13]),    .g_pre(g2[ 9]),    .p_pre(p2[ 9]),    .g_out(g3[13]),    .p_out(p3[13]));
    gp s3_11(.g_cur(g2[14]),    .p_cur(p2[14]),    .g_pre(g2[10]),    .p_pre(p2[10]),    .g_out(g3[14]),    .p_out(p3[14]));
    gp s3_12(.g_cur(g2[15]),    .p_cur(p2[15]),    .g_pre(g2[11]),    .p_pre(p2[11]),    .g_out(g3[15]),    .p_out(p3[15]));
    gp s3_13(.g_cur(g2[16]),    .p_cur(p2[16]),    .g_pre(g2[12]),    .p_pre(p2[12]),    .g_out(g3[16]),    .p_out(p3[16]));
    gp s3_14(.g_cur(g2[17]),    .p_cur(p2[17]),    .g_pre(g2[13]),    .p_pre(p2[13]),    .g_out(g3[17]),    .p_out(p3[17]));
    gp s3_15(.g_cur(g2[18]),    .p_cur(p2[18]),    .g_pre(g2[14]),    .p_pre(p2[14]),    .g_out(g3[18]),    .p_out(p3[18]));
    gp s3_16(.g_cur(g2[19]),    .p_cur(p2[19]),    .g_pre(g2[15]),    .p_pre(p2[15]),    .g_out(g3[19]),    .p_out(p3[19]));
    gp s3_17(.g_cur(g2[20]),    .p_cur(p2[20]),    .g_pre(g2[16]),    .p_pre(p2[16]),    .g_out(g3[20]),    .p_out(p3[20]));
    gp s3_18(.g_cur(g2[21]),    .p_cur(p2[21]),    .g_pre(g2[17]),    .p_pre(p2[17]),    .g_out(g3[21]),    .p_out(p3[21]));
    gp s3_19(.g_cur(g2[22]),    .p_cur(p2[22]),    .g_pre(g2[18]),    .p_pre(p2[18]),    .g_out(g3[22]),    .p_out(p3[22]));
    gp s3_20(.g_cur(g2[23]),    .p_cur(p2[23]),    .g_pre(g2[19]),    .p_pre(p2[19]),    .g_out(g3[23]),    .p_out(p3[23]));
    gp s3_21(.g_cur(g2[24]),    .p_cur(p2[24]),    .g_pre(g2[20]),    .p_pre(p2[20]),    .g_out(g3[24]),    .p_out(p3[24]));
    gp s3_22(.g_cur(g2[25]),    .p_cur(p2[25]),    .g_pre(g2[21]),    .p_pre(p2[21]),    .g_out(g3[25]),    .p_out(p3[25]));
    gp s3_23(.g_cur(g2[26]),    .p_cur(p2[26]),    .g_pre(g2[22]),    .p_pre(p2[22]),    .g_out(g3[26]),    .p_out(p3[26]));
    gp s3_24(.g_cur(g2[27]),    .p_cur(p2[27]),    .g_pre(g2[23]),    .p_pre(p2[23]),    .g_out(g3[27]),    .p_out(p3[27]));
    gp s3_25(.g_cur(g2[28]),    .p_cur(p2[28]),    .g_pre(g2[24]),    .p_pre(p2[24]),    .g_out(g3[28]),    .p_out(p3[28]));
    gp s3_26(.g_cur(g2[29]),    .p_cur(p2[29]),    .g_pre(g2[25]),    .p_pre(p2[25]),    .g_out(g3[29]),    .p_out(p3[29]));
    gp s3_27(.g_cur(g2[30]),    .p_cur(p2[30]),    .g_pre(g2[26]),    .p_pre(p2[26]),    .g_out(g3[30]),    .p_out(p3[30]));
    gp s3_28(.g_cur(g2[31]),    .p_cur(p2[31]),    .g_pre(g2[27]),    .p_pre(p2[27]),    .g_out(g3[31]),    .p_out(p3[31]));

    // Stage 4
    assign {g4[0], p4[0]} = {g3[0], p3[0]};
    assign {g4[1], p4[1]} = {g3[1], p3[1]};
    assign {g4[2], p4[2]} = {g3[2], p3[2]};
    assign {g4[3], p4[3]} = {g3[3], p3[3]};
    assign {g4[4], p4[4]} = {g3[4], p3[4]};
    assign {g4[5], p4[5]} = {g3[5], p3[5]};
    assign {g4[6], p4[6]} = {g3[6], p3[6]};
    assign {g4[7], p4[7]} = {g3[7], p3[7]};
    gp s4_01(.g_cur(g3[ 8]),    .p_cur(p3[ 8]),    .g_pre(g3[ 0]),    .p_pre(p3[ 0]),    .g_out(g4[ 8]),    .p_out(p4[ 8]));
    gp s4_02(.g_cur(g3[ 9]),    .p_cur(p3[ 9]),    .g_pre(g3[ 1]),    .p_pre(p3[ 1]),    .g_out(g4[ 9]),    .p_out(p4[ 9]));
    gp s4_03(.g_cur(g3[10]),    .p_cur(p3[10]),    .g_pre(g3[ 2]),    .p_pre(p3[ 2]),    .g_out(g4[10]),    .p_out(p4[10]));
    gp s4_04(.g_cur(g3[11]),    .p_cur(p3[11]),    .g_pre(g3[ 3]),    .p_pre(p3[ 3]),    .g_out(g4[11]),    .p_out(p4[11]));
    gp s4_05(.g_cur(g3[12]),    .p_cur(p3[12]),    .g_pre(g3[ 4]),    .p_pre(p3[ 4]),    .g_out(g4[12]),    .p_out(p4[12]));
    gp s4_06(.g_cur(g3[13]),    .p_cur(p3[13]),    .g_pre(g3[ 5]),    .p_pre(p3[ 5]),    .g_out(g4[13]),    .p_out(p4[13]));
    gp s4_07(.g_cur(g3[14]),    .p_cur(p3[14]),    .g_pre(g3[ 6]),    .p_pre(p3[ 6]),    .g_out(g4[14]),    .p_out(p4[14]));
    gp s4_08(.g_cur(g3[15]),    .p_cur(p3[15]),    .g_pre(g3[ 7]),    .p_pre(p3[ 7]),    .g_out(g4[15]),    .p_out(p4[15]));
    gp s4_09(.g_cur(g3[16]),    .p_cur(p3[16]),    .g_pre(g3[ 8]),    .p_pre(p3[ 8]),    .g_out(g4[16]),    .p_out(p4[16]));
    gp s4_10(.g_cur(g3[17]),    .p_cur(p3[17]),    .g_pre(g3[ 9]),    .p_pre(p3[ 9]),    .g_out(g4[17]),    .p_out(p4[17]));
    gp s4_11(.g_cur(g3[18]),    .p_cur(p3[18]),    .g_pre(g3[10]),    .p_pre(p3[10]),    .g_out(g4[18]),    .p_out(p4[18]));
    gp s4_12(.g_cur(g3[19]),    .p_cur(p3[19]),    .g_pre(g3[11]),    .p_pre(p3[11]),    .g_out(g4[19]),    .p_out(p4[19]));
    gp s4_13(.g_cur(g3[20]),    .p_cur(p3[20]),    .g_pre(g3[12]),    .p_pre(p3[12]),    .g_out(g4[20]),    .p_out(p4[20]));
    gp s4_14(.g_cur(g3[21]),    .p_cur(p3[21]),    .g_pre(g3[13]),    .p_pre(p3[13]),    .g_out(g4[21]),    .p_out(p4[21]));
    gp s4_15(.g_cur(g3[22]),    .p_cur(p3[22]),    .g_pre(g3[14]),    .p_pre(p3[14]),    .g_out(g4[22]),    .p_out(p4[22]));
    gp s4_16(.g_cur(g3[23]),    .p_cur(p3[23]),    .g_pre(g3[15]),    .p_pre(p3[15]),    .g_out(g4[23]),    .p_out(p4[23]));
    gp s4_17(.g_cur(g3[24]),    .p_cur(p3[24]),    .g_pre(g3[16]),    .p_pre(p3[16]),    .g_out(g4[24]),    .p_out(p4[24]));
    gp s4_18(.g_cur(g3[25]),    .p_cur(p3[25]),    .g_pre(g3[17]),    .p_pre(p3[17]),    .g_out(g4[25]),    .p_out(p4[25]));
    gp s4_19(.g_cur(g3[26]),    .p_cur(p3[26]),    .g_pre(g3[18]),    .p_pre(p3[18]),    .g_out(g4[26]),    .p_out(p4[26]));
    gp s4_20(.g_cur(g3[27]),    .p_cur(p3[27]),    .g_pre(g3[19]),    .p_pre(p3[19]),    .g_out(g4[27]),    .p_out(p4[27]));
    gp s4_21(.g_cur(g3[28]),    .p_cur(p3[28]),    .g_pre(g3[20]),    .p_pre(p3[20]),    .g_out(g4[28]),    .p_out(p4[28]));
    gp s4_22(.g_cur(g3[29]),    .p_cur(p3[29]),    .g_pre(g3[21]),    .p_pre(p3[21]),    .g_out(g4[29]),    .p_out(p4[29]));
    gp s4_23(.g_cur(g3[30]),    .p_cur(p3[30]),    .g_pre(g3[22]),    .p_pre(p3[22]),    .g_out(g4[30]),    .p_out(p4[30]));
    gp s4_24(.g_cur(g3[31]),    .p_cur(p3[31]),    .g_pre(g3[23]),    .p_pre(p3[23]),    .g_out(g4[31]),    .p_out(p4[31]));

    // Stage 5
    assign {g5[ 0], p5[ 0]} = {g4[ 0], p4[ 0]};
    assign {g5[ 1], p5[ 1]} = {g4[ 1], p4[ 1]};
    assign {g5[ 2], p5[ 2]} = {g4[ 2], p4[ 2]};
    assign {g5[ 3], p5[ 3]} = {g4[ 3], p4[ 3]};
    assign {g5[ 4], p5[ 4]} = {g4[ 4], p4[ 4]};
    assign {g5[ 5], p5[ 5]} = {g4[ 5], p4[ 5]};
    assign {g5[ 6], p5[ 6]} = {g4[ 6], p4[ 6]};
    assign {g5[ 7], p5[ 7]} = {g4[ 7], p4[ 7]};
    assign {g5[ 8], p5[ 8]} = {g4[ 8], p4[ 8]};
    assign {g5[ 9], p5[ 9]} = {g4[ 9], p4[ 9]};
    assign {g5[10], p5[10]} = {g4[10], p4[10]};
    assign {g5[11], p5[11]} = {g4[11], p4[11]};
    assign {g5[12], p5[12]} = {g4[12], p4[12]};
    assign {g5[13], p5[13]} = {g4[13], p4[13]};
    assign {g5[14], p5[14]} = {g4[14], p4[14]};
    assign {g5[15], p5[15]} = {g4[15], p4[15]};
    gp s5_01(.g_cur(g4[16]),    .p_cur(p4[16]),    .g_pre(g4[ 0]),    .p_pre(p4[ 0]),    .g_out(g5[16]),    .p_out(p5[16]));
    gp s5_02(.g_cur(g4[17]),    .p_cur(p4[17]),    .g_pre(g4[ 1]),    .p_pre(p4[ 1]),    .g_out(g5[17]),    .p_out(p5[17]));
    gp s5_03(.g_cur(g4[18]),    .p_cur(p4[18]),    .g_pre(g4[ 2]),    .p_pre(p4[ 2]),    .g_out(g5[18]),    .p_out(p5[18]));
    gp s5_04(.g_cur(g4[19]),    .p_cur(p4[19]),    .g_pre(g4[ 3]),    .p_pre(p4[ 3]),    .g_out(g5[19]),    .p_out(p5[19]));
    gp s5_05(.g_cur(g4[20]),    .p_cur(p4[20]),    .g_pre(g4[ 4]),    .p_pre(p4[ 4]),    .g_out(g5[20]),    .p_out(p5[20]));
    gp s5_06(.g_cur(g4[21]),    .p_cur(p4[21]),    .g_pre(g4[ 5]),    .p_pre(p4[ 5]),    .g_out(g5[21]),    .p_out(p5[21]));
    gp s5_07(.g_cur(g4[22]),    .p_cur(p4[22]),    .g_pre(g4[ 6]),    .p_pre(p4[ 6]),    .g_out(g5[22]),    .p_out(p5[22]));
    gp s5_08(.g_cur(g4[23]),    .p_cur(p4[23]),    .g_pre(g4[ 7]),    .p_pre(p4[ 7]),    .g_out(g5[23]),    .p_out(p5[23]));
    gp s5_09(.g_cur(g4[24]),    .p_cur(p4[24]),    .g_pre(g4[ 8]),    .p_pre(p4[ 8]),    .g_out(g5[24]),    .p_out(p5[24]));
    gp s5_10(.g_cur(g4[25]),    .p_cur(p4[25]),    .g_pre(g4[ 9]),    .p_pre(p4[ 9]),    .g_out(g5[25]),    .p_out(p5[25]));
    gp s5_11(.g_cur(g4[26]),    .p_cur(p4[26]),    .g_pre(g4[10]),    .p_pre(p4[10]),    .g_out(g5[26]),    .p_out(p5[26]));
    gp s5_12(.g_cur(g4[27]),    .p_cur(p4[27]),    .g_pre(g4[11]),    .p_pre(p4[11]),    .g_out(g5[27]),    .p_out(p5[27]));
    gp s5_13(.g_cur(g4[28]),    .p_cur(p4[28]),    .g_pre(g4[12]),    .p_pre(p4[12]),    .g_out(g5[28]),    .p_out(p5[28]));
    gp s5_14(.g_cur(g4[29]),    .p_cur(p4[29]),    .g_pre(g4[13]),    .p_pre(p4[13]),    .g_out(g5[29]),    .p_out(p5[29]));
    gp s5_15(.g_cur(g4[30]),    .p_cur(p4[30]),    .g_pre(g4[14]),    .p_pre(p4[14]),    .g_out(g5[30]),    .p_out(p5[30]));
    gp s5_16(.g_cur(g4[31]),    .p_cur(p4[31]),    .g_pre(g4[15]),    .p_pre(p4[15]),    .g_out(g5[31]),    .p_out(p5[31]));

    // Carry calculation
    c_gen carry_01(.g(g5[ 0]), .p(p5[ 0]), .c_pre(sub),  .c(c[ 0]));
    c_gen carry_02(.g(g5[ 1]), .p(p5[ 1]), .c_pre(c[ 0]), .c(c[ 1]));
    c_gen carry_03(.g(g5[ 2]), .p(p5[ 2]), .c_pre(c[ 1]), .c(c[ 2]));
    c_gen carry_04(.g(g5[ 3]), .p(p5[ 3]), .c_pre(c[ 2]), .c(c[ 3]));
    c_gen carry_05(.g(g5[ 4]), .p(p5[ 4]), .c_pre(c[ 3]), .c(c[ 4]));
    c_gen carry_06(.g(g5[ 5]), .p(p5[ 5]), .c_pre(c[ 4]), .c(c[ 5]));
    c_gen carry_07(.g(g5[ 6]), .p(p5[ 6]), .c_pre(c[ 5]), .c(c[ 6]));
    c_gen carry_08(.g(g5[ 7]), .p(p5[ 7]), .c_pre(c[ 6]), .c(c[ 7]));
    c_gen carry_09(.g(g5[ 8]), .p(p5[ 8]), .c_pre(c[ 7]), .c(c[ 8]));
    c_gen carry_10(.g(g5[ 9]), .p(p5[ 9]), .c_pre(c[ 8]), .c(c[ 9]));
    c_gen carry_11(.g(g5[10]), .p(p5[10]), .c_pre(c[ 9]), .c(c[10]));
    c_gen carry_12(.g(g5[11]), .p(p5[11]), .c_pre(c[10]), .c(c[11]));
    c_gen carry_13(.g(g5[12]), .p(p5[12]), .c_pre(c[11]), .c(c[12]));
    c_gen carry_14(.g(g5[13]), .p(p5[13]), .c_pre(c[12]), .c(c[13]));
    c_gen carry_15(.g(g5[14]), .p(p5[14]), .c_pre(c[13]), .c(c[14]));
    c_gen carry_16(.g(g5[15]), .p(p5[15]), .c_pre(c[14]), .c(c[15]));
    c_gen carry_17(.g(g5[16]), .p(p5[16]), .c_pre(c[15]), .c(c[16]));
    c_gen carry_18(.g(g5[17]), .p(p5[17]), .c_pre(c[16]), .c(c[17]));
    c_gen carry_19(.g(g5[18]), .p(p5[18]), .c_pre(c[17]), .c(c[18]));
    c_gen carry_20(.g(g5[19]), .p(p5[19]), .c_pre(c[18]), .c(c[19]));
    c_gen carry_21(.g(g5[20]), .p(p5[20]), .c_pre(c[19]), .c(c[20]));
    c_gen carry_22(.g(g5[21]), .p(p5[21]), .c_pre(c[20]), .c(c[21]));
    c_gen carry_23(.g(g5[22]), .p(p5[22]), .c_pre(c[21]), .c(c[22]));
    c_gen carry_24(.g(g5[23]), .p(p5[23]), .c_pre(c[22]), .c(c[23]));
    c_gen carry_25(.g(g5[24]), .p(p5[24]), .c_pre(c[23]), .c(c[24]));
    c_gen carry_26(.g(g5[25]), .p(p5[25]), .c_pre(c[24]), .c(c[25]));
    c_gen carry_27(.g(g5[26]), .p(p5[26]), .c_pre(c[25]), .c(c[26]));
    c_gen carry_28(.g(g5[27]), .p(p5[27]), .c_pre(c[26]), .c(c[27]));
    c_gen carry_29(.g(g5[28]), .p(p5[28]), .c_pre(c[27]), .c(c[28]));
    c_gen carry_30(.g(g5[29]), .p(p5[29]), .c_pre(c[28]), .c(c[29]));
    c_gen carry_31(.g(g5[30]), .p(p5[30]), .c_pre(c[29]), .c(c[30]));
    c_gen carry_32(.g(g5[31]), .p(p5[31]), .c_pre(c[30]), .c(c[31]));

    // Sum calculation
    assign sum = p ^ {c[30:0], sub};

    // Flags
    assign N = sum[7];           // Negative flag
    assign Z = (sum == 32'b0);   // Zero flag
    assign C = c[31];            // Carry flag
    assign V = c[31] ^ c[30];    // Overflow flaga

endmodule

module gp(
    input   wire    g_cur,
    input   wire    p_cur,
    input   wire    g_pre,
    input   wire    p_pre,
    output  wire    g_out,
    output  wire    p_out
);
    assign {g_out, p_out} = {(g_cur | (p_cur & g_pre)), (p_cur & p_pre)};
endmodule

module c_gen(
    input   wire    g,
    input   wire    p,
    input   wire    c_pre,
    output  wire    c
);
    assign c = g | (p & c_pre);
endmodule
