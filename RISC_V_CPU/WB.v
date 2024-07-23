module WB (
    input   wire    [31:0]      i_data_addr,
    input   wire    [31:0]      i_data_rd,
    input   wire    [31:0]      i_jal_addr,
    input   wire                i_memtoreg,
    input   wire                i_jal,
    output  wire    [31:0]      o_rd_data
);

    wire [1:0]  sel = {i_memtoreg, i_jal};

    assign o_rd_data = (sel == 2'b10) ? i_data_rd   : 
                       (sel == 2'b01) ? i_jal_addr  : i_data_addr;

endmodule