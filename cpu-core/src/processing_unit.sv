module ALU(input clk, input [2:0] func, input [31:0] operand_1, operand_2, output [31:0] result);
    // Change to always for pipelining.
    assign result = (func == 000)? operand_1 + operand_2 : // Add
                    (func == 001)? operand_1 - operand_2 : // Subtract
                    (func == 010)? operand_1 & operand_2 : // AND
                    (func == 011)? operand_1 | operand_2 : // OR
                    (func == 100)? operand_1 << operand_2[4:0] : // Shift left
                    (func == 101)? operand_1 >> operand_2[4:0] : // Shift right
                    (func == 110)? $signed(operand_1) >>> operand_2[4:0] : // Arithmetic shift right
                    // 111 is unused.
                    32'b0;
endmodule