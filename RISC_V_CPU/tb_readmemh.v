module tb_readmemh();

    reg     [7:0]   test_memory     [0:15];
    initial begin
        $display("Loading rom.");
        $readmemh("test.mem", test_memory);
    end

endmodule