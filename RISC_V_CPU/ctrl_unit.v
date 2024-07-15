`define     OP_R            7'b011_0011
`define     OP_B            7'b110_0011
`define     OP_I            7'b001_0011
`define     OP_I_LOAD       7'b000_0011
`define     OP_I_JALR       7'b110_0111
`define     OP_S            7'b010_0011
`define     OP_U_LUI        7'b011_0111
`define     OP_U_AUIPC      7'b001_0111
`define     OP_J_JAL        7'b110_1111

module ctrl_unit(

);
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
                    10'b0000000_000:    alu_ctrl <= 5'b00000; //ADD
                    10'b0100000_000:    alu_ctrl <= 5'b10000; //SUB
                    10'b0000000_001:    alu_ctrl <= 5'b00100; //SLL
                    10'b0000000_010:    alu_ctrl <= 5'b10111; //SLT
                    10'b0000000_011:    alu_ctrl <= 5'b11000; //SLTU
                    10'b0000000_100:    alu_ctrl <= 5'b00011; //XOR
                    10'b0000000_101:    alu_ctrl <= 5'b00101; //SRL
                    10'b0100000_101:    alu_ctrl <= 5'b00110; //SRA
                    10'b0000000_110:    alu_ctrl <= 5'b00010; //OR
                    10'b0000000_111:    alu_ctrl <= 5'b00001; //AND
                    default:    alu_ctrl <= 5'bxxxxx;
                endcase
            
            `OP_I:
                case ({funct7, funct3})
                    10'b0000000_001:    alu_ctrl <= 5'b00100;   //SLLI
                    10'b0000000_101:    alu_ctrl <= 5'b00110;   //SRLI
                    10'b0100000_101:    alu_ctrl <= 5'b00110;   //SRAI
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

);

endmodule