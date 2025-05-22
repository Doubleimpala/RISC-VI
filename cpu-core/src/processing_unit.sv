module ALU(input clk, input [2:0] func, input [31:0] operand_1, operand_2, output [31:0] result);
    // Change to always for pipelining.
    assign result = (func == 000)? operand_1 + operand_2 :
                    (func == 001)? operand_1 - operand_2 :
                    (func == 010)? operand_1 & operand_2 :
                    (func == 011)? operand_1 | operand_2 :
                    32'b0;
                    // Oppurtunity for added functionality.
endmodule