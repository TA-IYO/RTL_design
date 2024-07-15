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

    add_sub adder_subtractor (.a(a), .b(b2), .cin(alu_ctrl[4]), .sum(sum), .N(N), .Z(Z), .C(C), .V(V));

endmodule

module add_sub (
    input   wire    [31:0]  a,    
    input   wire    [31:0]  b,   
    input   wire            cin,
    output  wire    [31:0]  sum,
    output  wire            N, Z, C, V   
);
    wire    [31:0]  cout;

    adder_1bit bit31 (.a(a[31]), .b(b[31]), .cin(cout[30]), .sum(sum[31]), .cout(cout[31]));
    adder_1bit bit30 (.a(a[30]), .b(b[30]), .cin(cout[29]), .sum(sum[30]), .cout(cout[30]));
    adder_1bit bit29 (.a(a[29]), .b(b[29]), .cin(cout[28]), .sum(sum[29]), .cout(cout[29]));
    adder_1bit bit28 (.a(a[28]), .b(b[28]), .cin(cout[27]), .sum(sum[28]), .cout(cout[28]));

    adder_1bit bit27 (.a(a[27]), .b(b[27]), .cin(cout[26]), .sum(sum[27]), .cout(cout[27]));
    adder_1bit bit26 (.a(a[26]), .b(b[26]), .cin(cout[25]), .sum(sum[26]), .cout(cout[26]));
    adder_1bit bit25 (.a(a[25]), .b(b[25]), .cin(cout[24]), .sum(sum[25]), .cout(cout[25]));
    adder_1bit bit24 (.a(a[24]), .b(b[24]), .cin(cout[23]), .sum(sum[24]), .cout(cout[24]));

    adder_1bit bit23 (.a(a[23]), .b(b[23]), .cin(cout[22]), .sum(sum[23]), .cout(cout[23]));
    adder_1bit bit22 (.a(a[22]), .b(b[22]), .cin(cout[21]), .sum(sum[22]), .cout(cout[22]));
    adder_1bit bit21 (.a(a[21]), .b(b[21]), .cin(cout[20]), .sum(sum[21]), .cout(cout[21]));
    adder_1bit bit20 (.a(a[20]), .b(b[20]), .cin(cout[19]), .sum(sum[20]), .cout(cout[20]));

    adder_1bit bit19 (.a(a[19]), .b(b[19]), .cin(cout[18]), .sum(sum[19]), .cout(cout[19]));
    adder_1bit bit18 (.a(a[18]), .b(b[18]), .cin(cout[17]), .sum(sum[18]), .cout(cout[18]));
    adder_1bit bit17 (.a(a[17]), .b(b[17]), .cin(cout[16]), .sum(sum[17]), .cout(cout[17]));
    adder_1bit bit16 (.a(a[16]), .b(b[16]), .cin(cout[15]), .sum(sum[16]), .cout(cout[16]));

    adder_1bit bit15 (.a(a[15]), .b(b[15]), .cin(cout[14]), .sum(sum[15]), .cout(cout[15]));
    adder_1bit bit14 (.a(a[14]), .b(b[14]), .cin(cout[13]), .sum(sum[14]), .cout(cout[14]));
    adder_1bit bit13 (.a(a[13]), .b(b[13]), .cin(cout[12]), .sum(sum[13]), .cout(cout[13]));
    adder_1bit bit12 (.a(a[12]), .b(b[12]), .cin(cout[11]), .sum(sum[12]), .cout(cout[12]));

    adder_1bit bit11 (.a(a[11]), .b(b[11]), .cin(cout[10]), .sum(sum[11]), .cout(cout[11]));
    adder_1bit bit10 (.a(a[10]), .b(b[10]), .cin(cout[9]), .sum(sum[10]), .cout(cout[10]));
    adder_1bit bit09 (.a(a[9]), .b(b[9]), .cin(cout[8]), .sum(sum[9]), .cout(cout[9]));
    adder_1bit bit08 (.a(a[8]), .b(b[8]), .cin(cout[7]), .sum(sum[8]), .cout(cout[8]));

    adder_1bit bit07 (.a(a[7]), .b(b[7]), .cin(cout[6]), .sum(sum[7]), .cout(cout[7]));
    adder_1bit bit06 (.a(a[6]), .b(b[6]), .cin(cout[5]), .sum(sum[6]), .cout(cout[6]));
    adder_1bit bit05 (.a(a[5]), .b(b[5]), .cin(cout[4]), .sum(sum[5]), .cout(cout[5]));
    adder_1bit bit04 (.a(a[4]), .b(b[4]), .cin(cout[3]), .sum(sum[4]), .cout(cout[4]));

    adder_1bit bit03 (.a(a[3]), .b(b[3]), .cin(cout[2]), .sum(sum[3]), .cout(cout[3]));
    adder_1bit bit02 (.a(a[2]), .b(b[2]), .cin(cout[1]), .sum(sum[2]), .cout(cout[2]));
    adder_1bit bit01 (.a(a[1]), .b(b[1]), .cin(cout[0]), .sum(sum[1]), .cout(cout[1]));
    adder_1bit bit00 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(cout[0]));

    assign N = sum[31];
    assign Z = ~(|sum); //(sum == 32'b0);
    assign C = cout[31];
    assign V = cout[31] ^ cout[30];

endmodule

module adder_1bit(
    input   wire    a,
    input   wire    b,
    input   wire    cin,
    output  wire    sum,
    output  wire    cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule
