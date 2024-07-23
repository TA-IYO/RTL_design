module top(
    input   wire    clk,
    input   wire    rstn
);
    wire    [31:0]      pc;
    wire    [31:0]      instruction;

    IF instruction_fetch (
        .i_clk          (clk        ),
        .i_rstn         (rstn       ),
        .o_pc           (pc         ),
        .o_inst         (instruction)
    );

    ID instruction_decode (
        i_clk           (clk        ),
        i_inst          (instruction),
        i_rd            (rd         ),
        i_rd_data       (rd_data    ),
        i_pc            (if_pc      ),
        o_pc            (id_pc      ),
        o_rs1_data      (rs1_data   ),
        o_rs2_data      (rs2_data   ),
        o_imm           (immediate  ),
        o_alu_src       (alu_src    ),
        o_alu_ctrl      (alu_ctrl   ),
        o_jal           (jal        ),
        o_beq           (beq        ),
        o_memwrite      (memwrite   ),
        o_memtoreg      (memtoreg   ),
    );

    EXE execution (
        i_pc            (pc         ),
        i_rs1_data      (rs1_data   ),
        i_rs2_data      (rs2_data   ),
        i_imm           (immediate  ),
        i_wb_data       (i_wb_data  ),
        i_alu_src       (alu_src    ),      
        i_alu_ctrl      (alu_ctrl   ),
        o_wb_data       (wb_data    ),
        o_pc_branch     (pc_branch  ),
        o_rd_data       (rd_data    ),
        o_data_addr     (data_addr  ),
        o_data_wr       (data_wr    )
    );

    MEM data_memory (
        i_clk           (clk            ),
        i_we            (memwrite       ),
        i_data_addr     (data_addr      ),
        i_data_wr       (data_wr        ),
        o_data_addr_mux (data_addr_mux  ),
        o_data_rd       (data_rd        )
    );

    WB write_back (
        i_data_addr_mux (data_addr_mux  ),
        i_data_rd       (data_rd        ),
        i_memtoreg      (memtoreg       ),
        o_wb_data       (wb_data        )
    );

endmodule