module tb_data_memory;

    reg    		clk;
    reg			rstn;
    reg			we;
    reg			[31:0] addr;
    reg			[31:0] write_data;
    wire		[31:0] read_data;

initial begin
    clk = 0;
    forever #5
    clk = ~clk;
end

initial begin
    rstn = 0;
#10
    rstn = 1;
end

initial begin
    addr = 0; #10
    addr = 1; #10
    addr = 2; #10
    addr = 3; 
end

data_memory dut(
    .clk                (clk),       
    .we                 (1'b0),      
    .addr               (addr),      
    .write_data         (32'h0),
    .read_data          (read_data)
);

initial begin
    $dumpfile("sim/tb_data_memory.vcd");
    $dumpvars(0, tb_data_memory);
    $dumpflush;
    #100
    $finish;
end

endmodule


module data_memory (
    input   wire                clk,       
    input   wire                we,      
    input   wire    [31:0]      addr,      
    input   wire    [31:0]      write_data,
    output  reg     [31:0]      read_data  
);

    reg [7:0] memory [0:3];

    initial begin
        $readmemh("test.mem", memory);
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