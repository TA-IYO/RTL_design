
module IF(
    input   wire                i_clk,
    input   wire                i_rstn,
    input   wire                i_btaken,
    input   wire                i_jal,
    input   wire    [31:0]      i_imm_i,
    input   wire    [31:0]      i_imm_j,
    output  wire    [31:0]      o_jal_addr,
    output  wire    [31:0]      o_inst
);
    wire    clk     =   i_clk;
    wire    rstn    =   i_rstn;
    wire    [31:0]      i_pc;
    wire    [31:0]      o_pc;
    wire    [31:0]      next_pc;

    wire    [31:0]      imm_i = (i_imm_i << 1);
    wire    [31:0]      imm_j = (i_imm_j << 1);

    wire    [31:0]      imm_i_offset = i_imm_i + o_pc;
    wire    [31:0]      imm_j_offset = i_imm_j + o_pc;

    wire    [31:0]      btaken = i_btaken ? imm_i_offset : next_pc;
    wire    [31:0]      jal    = i_jal    ? imm_j_offset : btaken;
    assign              i_pc = jal; 

    assign              o_jal_addr = next_pc;

    pc program_counter(
        .clk        (clk    ),
        .rstn       (rstn   ),
        .i_pc       (i_pc   ),
        .o_pc       (o_pc   ),
        .o_next_pc  (next_pc)
    );

    inst_memory INST (
        .clk         (clk    ),       
        .we          (1'b0   ),      
        .addr        (o_pc   ),      
        .write_data  (32'h0  ),
        .read_data   (o_inst )
    );

endmodule

module pc(
    input   wire                clk,
    input   wire                rstn,
    input   wire    [31:0]      i_pc,
    output  reg     [31:0]      o_pc,
    output  reg     [31:0]      o_next_pc
);
    always @(posedge clk, negedge rstn) begin
        if (~rstn)  begin
            o_pc        <=  32'h0;
            o_next_pc   <=  32'h0;
        end
        else    begin
            o_pc        <=  i_pc;
            o_next_pc   <=  i_pc + 4;
        end
    end
endmodule



module inst_memory (
    input   wire                clk,       
    input   wire                we,      
    input   wire    [31:0]      addr,      
    input   wire    [31:0]      write_data,
    output  reg     [31:0]      read_data  
);

    reg [31:0] memory [0:255];

    initial begin
        $readmemh("inst_mem.mem", memory, 0, 255);
    end

    always @(posedge clk) begin
        if (we) begin
            memory[addr[9:2]] <= write_data;  
        end
    end

    always @(*) begin
        read_data = memory[addr[9:2]];        
    end

endmodule