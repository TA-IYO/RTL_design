`include "alu.v"
`timescale 1ps/1ps
module tb_alu;
    reg     [31:0]  a, b;
    reg     [4:0]   alu_ctrl;
    wire    [31:0]  result;
    wire             N, Z, C, V;

alu u0 (.a(a), .b(b), .alu_ctrl(alu_ctrl), .result(result), .N(N), .Z(Z), .C(C), .V(V));

    initial begin
            
            a = 32'hf0000000;
            b = 32'h90000000;
            alu_ctrl = 5'b00000;
        #10 alu_ctrl = 5'b00001; 
        #10 alu_ctrl = 5'b00010; 
        #10 alu_ctrl = 5'b00011; 
        #10 alu_ctrl = 5'b00100; 
        #10 alu_ctrl = 5'b00101; 
        #10 alu_ctrl = 5'b00110; 
        #10 alu_ctrl = 5'b00111; 
        #10 alu_ctrl = 5'b01000; 

        #10 a = 32'h00000000;
            b = 32'h00000000;
            alu_ctrl = 5'b00000;
        #10 alu_ctrl = 5'b00001; 
        #10 alu_ctrl = 5'b00010; 
        #10 alu_ctrl = 5'b00011; 
        #10 alu_ctrl = 5'b00100; 
        #10 alu_ctrl = 5'b00101; 
        #10 alu_ctrl = 5'b00110; 
        #10 alu_ctrl = 5'b00111;    
        #10 alu_ctrl = 5'b01000;  

        #10 a = 32'h004400ff;
            b = 32'hf0000fff;
            alu_ctrl = 5'b00000;
        #10 alu_ctrl = 5'b00001; 
        #10 alu_ctrl = 5'b00010; 
        #10 alu_ctrl = 5'b00011; 
        #10 alu_ctrl = 5'b00100; 
        #10 alu_ctrl = 5'b00101; 
        #10 alu_ctrl = 5'b00110; 
        #10 alu_ctrl = 5'b00111; 
        #10 alu_ctrl = 5'b01000;       

        #10 a = 32'h00000419;
            b = 32'h00040004;
            alu_ctrl = 5'b00000;
        #10 alu_ctrl = 5'b00001; 
        #10 alu_ctrl = 5'b00010; 
        #10 alu_ctrl = 5'b00011; 
        #10 alu_ctrl = 5'b00100; 
        #10 alu_ctrl = 5'b00101; 
        #10 alu_ctrl = 5'b00110; 
        #10 alu_ctrl = 5'b00111; 
        #10 alu_ctrl = 5'b01000;     

        #10 a = 32'hf00fffff;
            b = 32'h80008000;
            alu_ctrl = 5'b00000;
        #10 alu_ctrl = 5'b00001; 
        #10 alu_ctrl = 5'b00010; 
        #10 alu_ctrl = 5'b00011; 
        #10 alu_ctrl = 5'b00100; 
        #10 alu_ctrl = 5'b00101; 
        #10 alu_ctrl = 5'b00110; 
        #10 alu_ctrl = 5'b00111; 
        #10 alu_ctrl = 5'b01000;     
    end

    initial begin
        $dumpfile("tb_alu.vcd");
        $dumpvars(0, tb_alu);
        $dumpflush;
        #600
        $finish;    
    end
endmodule