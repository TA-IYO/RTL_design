module MEM (
    input   wire                i_clk,
    input   wire                i_we,
    input   wire    [31:0]      i_data_addr,
    input   wire    [31:0]      i_data_wr,
    output  wire    [31:0]      o_data_addr,
    output  wire    [31:0]      o_data_rd
);
    wire            clk = i_clk;
    wire            we = i_we;

data_memory DATA (
    .clk                (clk        ),           
    .we                 (we         ),            
    .addr               (i_data_addr),          
    .write_data         (i_data_wr  ),    
    .read_data          (o_data_rd  )
);

    assign o_data_addr = i_data_addr;

endmodule



module data_memory (
    input   wire                clk,       
    input   wire                we,      
    input   wire    [31:0]      addr,      
    input   wire    [31:0]      write_data,
    output  reg     [31:0]      read_data  
);

    reg [31:0] memory [0:255];

    initial begin
        $readmemh("data_mem.mem", memory);
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
