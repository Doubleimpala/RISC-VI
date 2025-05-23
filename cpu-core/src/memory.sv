module MAR(input clk, input ld, input [31:0] address_in, output [31:0] address_out);
    reg [31:0] mar_reg;
    always @(posedge clk) begin
        if(ld) 
            mar_reg <= address_in;
    end
    assign address_out = mar_reg;
endmodule 


module memory(input clk, rw, input [31:0] address, data_in, output [31:0] data_out);
    reg [31:0] memory [0:4095];

    always @(posedge clk) begin
        if(rw)
            memory[address[11:0]] <= data;
    end

    assign data_out = memory[address[11:0]];

endmodule

module MDR(input clk, input ld, input [31:0] data_in, output [31:0] data_out);
    reg [31:0] mdr_reg;
    always @(posedge clk) begin
        if(ld) 
            mdr_reg <= data_in;
    end
    assign data_out = mdr_reg;
endmodule 