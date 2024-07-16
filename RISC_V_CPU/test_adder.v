module test_adder (
    input       [7:0]       a,
    input       [7:0]       b,
    input                   sub,
    output      [7:0]       sum,
    output                  N,   // Negative flag
    output                  Z,   // Zero flag
    output                  C,   // Carry flag
    output                  V    // Overflow flag
);

    wire [31:0] b_eff;       // Effective B (B or ~B)
    wire [31:0] p, g;        // Generate and Propagate
    wire [31:0] c;           // Carry bits

    // Effective B calculation based on Sub signal
    assign b_eff = b ^ {32{sub}};  // XOR with Sub to get B or ~B

    // Generate and Propagate
    // Stage 0
    assign g = a & b_eff;   // Generate
    assign p = a ^ b_eff;   // Propagate

    // Combine multiple stages for Kogge-Stone logic
    wire    [7:0]  g1, p1, g2, p2, g3, p3, g4, p4, g5, p5;

    // Stage 1
    assign {g1[0], p1[0]} = {g[0], p[0]};
    gp s1_01(.g_cur(g[1]), .p_cur(p[1]), .g_pre(g[0]), .p_pre(p[0]), .g_out(g1[1]), .p_out(p1[1]));
    gp s1_02(.g_cur(g[2]), .p_cur(p[2]), .g_pre(g[1]), .p_pre(p[1]), .g_out(g1[2]), .p_out(p1[2]));
    gp s1_03(.g_cur(g[3]), .p_cur(p[3]), .g_pre(g[2]), .p_pre(p[2]), .g_out(g1[3]), .p_out(p1[3]));
    gp s1_04(.g_cur(g[4]), .p_cur(p[4]), .g_pre(g[3]), .p_pre(p[3]), .g_out(g1[4]), .p_out(p1[4]));
    gp s1_05(.g_cur(g[5]), .p_cur(p[5]), .g_pre(g[4]), .p_pre(p[4]), .g_out(g1[5]), .p_out(p1[5]));
    gp s1_06(.g_cur(g[6]), .p_cur(p[6]), .g_pre(g[5]), .p_pre(p[5]), .g_out(g1[6]), .p_out(p1[6]));
    gp s1_07(.g_cur(g[7]), .p_cur(p[7]), .g_pre(g[6]), .p_pre(p[6]), .g_out(g1[7]), .p_out(p1[7]));

    // Stage 2
    assign {g2[0], p2[0]} = {g1[0], p1[0]};
    assign {g2[1], p2[1]} = {g1[1], p1[1]};
    gp s2_01(.g_cur(g1[2]), .p_cur(p1[2]), .g_pre(g1[1]), .p_pre(p1[1]), .g_out(g2[2]), .p_out(p2[2]));
    gp s2_02(.g_cur(g1[3]), .p_cur(p1[3]), .g_pre(g1[2]), .p_pre(p1[2]), .g_out(g2[3]), .p_out(p2[3]));
    gp s2_03(.g_cur(g1[4]), .p_cur(p1[4]), .g_pre(g1[3]), .p_pre(p1[3]), .g_out(g2[4]), .p_out(p2[4]));
    gp s2_04(.g_cur(g1[5]), .p_cur(p1[5]), .g_pre(g1[4]), .p_pre(p1[4]), .g_out(g2[5]), .p_out(p2[5]));
    gp s2_05(.g_cur(g1[6]), .p_cur(p1[6]), .g_pre(g1[5]), .p_pre(p1[5]), .g_out(g2[6]), .p_out(p2[6]));
    gp s2_06(.g_cur(g1[7]), .p_cur(p1[7]), .g_pre(g1[6]), .p_pre(p1[6]), .g_out(g2[7]), .p_out(p2[7]));

    // Stage 3
    assign {g3[0], p3[0]} = {g2[0], p2[0]};
    assign {g3[1], p3[1]} = {g2[1], p2[1]};
    assign {g3[2], p3[2]} = {g2[2], p2[2]};
    assign {g3[3], p3[3]} = {g2[3], p2[3]};
    gp s3_01(.g_cur(g2[4]), .p_cur(p2[4]), .g_pre(g2[3]), .p_pre(p2[3]), .g_out(g3[4]), .p_out(p3[4]));
    gp s3_02(.g_cur(g2[5]), .p_cur(p2[5]), .g_pre(g2[4]), .p_pre(p2[4]), .g_out(g3[5]), .p_out(p3[5]));
    gp s3_03(.g_cur(g2[6]), .p_cur(p2[6]), .g_pre(g2[5]), .p_pre(p2[5]), .g_out(g3[6]), .p_out(p3[6]));
    gp s3_04(.g_cur(g2[7]), .p_cur(p2[7]), .g_pre(g2[6]), .p_pre(p2[6]), .g_out(g3[7]), .p_out(p3[7]));

    // Carry calculation
    assign c[0] = sub;
    c_gen carry_1(.g(g[1]), .p(p[1]), .c_pre(c[0]), .c(c[1]));
    c_gen carry_2(.g(g[2]), .p(p[2]), .c_pre(c[1]), .c(c[2]));
    c_gen carry_3(.g(g[3]), .p(p[3]), .c_pre(c[2]), .c(c[3]));
    c_gen carry_4(.g(g[4]), .p(p[4]), .c_pre(c[3]), .c(c[4]));
    c_gen carry_5(.g(g[5]), .p(p[5]), .c_pre(c[4]), .c(c[5]));
    c_gen carry_6(.g(g[6]), .p(p[6]), .c_pre(c[5]), .c(c[6]));
    c_gen carry_7(.g(g[7]), .p(p[7]), .c_pre(c[6]), .c(c[7]));

    // Sum calculation
    assign sum = p ^ c;

    // Flags
    assign N = sum[7];          // Negative flag
    assign Z = (sum == 7'b0);   // Zero flag
    assign C = c[7];             // Carry flag
    assign V = c[7] ^ c[7];  // Overflow flag

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