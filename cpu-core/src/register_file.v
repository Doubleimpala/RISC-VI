//Register file.
//With 32 registers, each one 5 bit addressable, supporting 32 bit data.

module register_file(input clk, rst, rw, 
                    input [4:0] source1, source2, dest, 
                    input [31:0] write_data, 
                    output [31:0] read_data1, read_data2);

    reg [31:0] registers [0:31];

    assign read_data1 = registers[source1];
    assign read_data2 = registers[source2];

    always @(posedge clk) begin
        if(rw)
            registers[dest] <= write_data;
    end
endmodule