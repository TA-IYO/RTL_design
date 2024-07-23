module IF(
    input   wire                i_clk,
    input   wire                i_rstn,
    output  wire    [31:0]      o_pc,
    output  wire    [31:0]      o_inst
);
    wire    clk     =   i_clk;
    wire    rstn    =   i_rstn;
    wire    pc      =   o_pc;
    wire    [31:0]      inst;
    wire    [31:0]      o_inst = inst;

    pc program_counter(
        .clk        (clk),
        .rstn       (rstn),
        .pc         (o_pc)
    );

    inst_memory INST (
        clk         (clk    ),       
        we          (1'b0   ),      
        addr        (pc     ),      
        write_data  (32'h0  ),
        read_data   (inst   )
    );


endmodule

module pc(
    input   wire            clk,
    input   wire            rstn,
    output  reg     [31:0]  pc
);
    always @(posedge clk, negedge rstn) begin
        if (~rstn)
            pc  <=  32'h0;
        else
            pc  <=  pc + 4;
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
        $readmemh("inst_mem.hex", memory);
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