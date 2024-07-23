`define     OP_R            7'b011_0011
`define     OP_B            7'b110_0011
`define     OP_I            7'b001_0011
`define     OP_I_LOAD       7'b000_0011
`define     OP_I_JALR       7'b110_0111
`define     OP_S            7'b010_0011
`define     OP_U_LUI        7'b011_0111
`define     OP_U_AUIPC      7'b001_0111
`define     OP_J_JAL        7'b110_1111

module ID(
    input   wire                i_clk,
    input   wire    [31:0]      i_inst,
    input   wire    [4:0 ]      i_rd,
    input   wire    [31:0]      i_rd_data,
    input   wire    [31:0]      i_pc,
    output  wire    [31:0]      o_pc,
    output  wire    [31:0]      o_rs1_data,
    output  wire    [31:0]      o_rs2_data,
    output  wire    [31:0]      o_imm,
    output  wire                o_alu_src,
    output  wire    [4:0 ]      o_alu_ctrl,
    output  wire                o_jal,
    output  wire                o_beq,
    output  wire                o_memwrite,
    output  wire                o_memtoreg,
);
    wire            clk = i_clk;
    wire            inst = i_inst;
    wire    [6:0]   funct7;
    wire    [4:0]   rs2, rs1;
    wire    [2:0]   funct3;
    wire    [4:0]   rd;
    wire    [6:0]   opcode;

    wire    [31:0]  rs1_data, rs2_data;
    reg     [31:0]  rd_data;
    wire    [4:0]   alu_ctrl;
    wire            regwrite;
    reg             pc; 
    wire    [31:0]  rd_data;
    wire            memtoreg;

    assign funct7   =   inst[31:25];
    assign rs2      =   inst[24:20];
    assign rs1      =   inst[19:15];
    assign funct3   =   inst[14:12];
    assign rd       =   inst[11:7];
    assign opcode   =   inst[6:0];
    assign o_alu_ctrl = alu_ctrl;

ctrl_unit control_unit(
    .opcode         (opcode)    ,
    .funct7         (funct7)    ,
    .funct3         (funct3)    ,
    .alu_ctrl       (alu_ctrl)  ,
    .regwrite       (regwrite)  ,
    .alu_src        (o_alu_src) ,
    .jal            (o_jal)     ,
    .beq            (o_beq)     ,
    .memwrite       (o_memwrite),
    .memtoreg       (o_memtoreg)
);

regfile register_files(
    .clk        (clk),
    .we         (regwrite),
    .rs1        (rs1),
    .rs2        (rs2),
    .rd         (rd),
    .rd_data    (rd_data),
    .rs1_data   (rs1_data),
    .rs2_data   (rs2_data)
);

always @(posedge clk)
    pc <= i_pc;
assign o_pc = pc;
assign o_imm[31:0] = {{20{inst[31]}}, inst[31:20]} ;

endmodule



module ctrl_unit(
    input   wire    [6:0]   opcode,
    input   wire    [6:0]   funct7,
    input   wire    [2:0]   funct3,
    output  wire    [4:0]   alu_ctrl,
    output  wire            regwrite,
    output  wire            alu_src,
    output  wire            jal,
    output  wire            beq,
    output  wire            memwrite,
    output  wire            memtoreg
);
    wire    [6:0]   i_opcode = opcode;
    wire    [6:0]   i_funct7 = funct7;
    wire    [2:0]   i_funct3 = funct3;
    wire    [4:0]   o_alu_ctrl;
    wire            o_regwrite;
    assign          alu_ctrl = o_alu_ctrl;
    assign          regwrite = o_regwrite;

    alu_det alu_ctrl_sig(
        .opcode     (i_opcode),
        .funct7     (i_funct7),
        .funct3     (i_funct3),
        .alu_ctrl   (o_alu_ctrl)
    );

    rw_det register_wr_sig(
        .opcode     (i_opcode),
        .regwrite   (o_regwrite)
    );

    assign alu_src = (opcode == 7'b0110011) ? 0 :
                     (opcode == 7'b0010011) ? 1 :
                     alu_src;

    assign memwrite = (opcode == 7'b0100011) ? 1 : 0;

    assign memtoreg = (opcode == 7'b0000011) ? 1 : 0; 

endmodule

module alu_det(
    input   wire    [6:0]   opcode,
    input   wire    [6:0]   funct7,
    input   wire    [2:0]   funct3,
    output  reg     [4:0]   alu_ctrl
);
    always @(*) begin
        case (opcode)
            `OP_R:
                case ({funct7, funct3})
                    10'b0000000_000:    alu_ctrl <= 5'b00000;  //ADD
                    10'b0100000_000:    alu_ctrl <= 5'b10000;  //SUB
                    10'b0000000_001:    alu_ctrl <= 5'b00100;  //SLL
                    10'b0000000_010:    alu_ctrl <= 5'b10111;  //SLT
                    10'b0000000_011:    alu_ctrl <= 5'b11000;  //SLTU
                    10'b0000000_100:    alu_ctrl <= 5'b00011;  //XOR
                    10'b0000000_101:    alu_ctrl <= 5'b00101;  //SRL
                    10'b0100000_101:    alu_ctrl <= 5'b00110;  //SRA
                    10'b0000000_110:    alu_ctrl <= 5'b00010;  //OR
                    10'b0000000_111:    alu_ctrl <= 5'b00001;  //AND
                    default:    alu_ctrl <= 5'bxxxxx;
                endcase
            
            `OP_I:
                case ({funct7, funct3})
                    10'b0000000_001:    alu_ctrl <= 5'b00100;  //SLLI
                    10'b0000000_101:    alu_ctrl <= 5'b00110;  //SRLI
                    10'b0100000_101:    alu_ctrl <= 5'b00110;  //SRAI
                    10'bxxxxxxx_000:    alu_ctrl <= 5'b00000;  //ADDI
                    10'bxxxxxxx_010:    alu_ctrl <= 5'b10111;  //SLTI
                    10'bxxxxxxx_011:    alu_ctrl <= 5'b11000;  //SLTIU
                    10'bxxxxxxx_100:    alu_ctrl <= 5'b00011;  //XORI
                    10'bxxxxxxx_110:    alu_ctrl <= 5'b00010;  //ORI
                    10'bxxxxxxx_111:    alu_ctrl <= 5'b00001;  //ANDI
                    default:    alu_ctrl <= 5'bxxxxx;
                endcase
            
            `OP_I_LOAD,
            `OP_I_JALR,
            `OP_S,
            `OP_U_LUI,
            `OP_U_AUIPC,
            `OP_J_JAL:
                alu_ctrl <= 5'b00000;

            `OP_B:
                alu_ctrl <= 5'b10000;   //SUB

            default: alu_ctrl <= 5'b00000;
        endcase
    end
endmodule

module rw_det(
    input   wire    [6:0]   opcode,
    output  reg             regwrite   
);
    always @(*) begin
        case (opcode)
            `OP_R:          regwrite    <= 1'b1;       
            `OP_B:          regwrite    <= 1'b0;       
            `OP_I:          regwrite    <= 1'b1;       
            `OP_I_LOAD:     regwrite    <= 1'b1;  
            `OP_I_JALR:     regwrite    <= 1'b1;  
            `OP_S:          regwrite    <= 1'b0;       
            `OP_U_LUI:      regwrite    <= 1'b1;   
            `OP_U_AUIPC:    regwrite    <= 1'b1; 
            `OP_J_JAL:      regwrite    <= 1'b1;   
            default:        regwrite    <= 1'b0;
        endcase
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