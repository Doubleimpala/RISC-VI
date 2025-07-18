//Register file.
//With 32 registers, each one 5 bit addressable, supporting 32 bit data.

module register_file(input clk, rst, rw, 
                    input [4:0] source1, source2, dest, 
                    input [31:0] write_data, 
                    output [31:0] read_data1, read_data2);

    reg [31:0] registers [1:31];

    assign read_data1 = (source1 == 0)? 0 : registers[source1];
    assign read_data2 = (source2 == 0)? 0 : registers[source2];

    always @(posedge clk) begin
        if(rw && dest != 0)
            registers[dest] <= write_data;
    end
endmodule