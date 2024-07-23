module WB (
    input   wire    [31:0]      i_data_addr_mux,
    input   wire    [31:0]      i_data_rd,
    input   wire                i_memtoreg;
    output  wire    [31:0]      o_wb_data
);

assign o_wb_data = memtoreg ? i_memtoreg : i_data_addr_mux;

endmodule