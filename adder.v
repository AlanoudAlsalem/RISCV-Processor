// The adder, in its two versions, is used for incrementing the PC
module adder(
    input  [31:0] operand1,
    input  [31:0] operand2,
    output reg [31:0] sum
);
    always @ (*) begin
        sum = operand1 + operand2;
    end

endmodule // adder

module adder_testbench;
    reg [31:0] op1, op2;
    wire [31:0] sum;

    adder DUT(
        .operand1(op1),
        .operand2(op2),
        .sum(sum)
    );

    initial begin
        op1 = 32'b0;
        op2 = 32'b100;
        #1
        $display("%d + %d = %d", op1, op2, sum);
    end
endmodule // testbench


