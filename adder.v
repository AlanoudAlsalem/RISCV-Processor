// The adder, in its two versions, is used for incrementing the PC

module adder(
    input [63:0] operand1,
    input [63:0] operand2,
    output reg [63:0] sum
);

    assign sum = operand1 + operand2;

endmodule