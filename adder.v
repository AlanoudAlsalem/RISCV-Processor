// The adder, in its two versions, is used for incrementing the PC
module adder(
    input  [31:0] operand1,
    input  [31:0] operand2,
    output [31:0] sum
);
    
    assign sum = operand1 + $signed(operand2);

endmodule