module pc_adder(input[31:0] operand1;
    input[31:0] operand2;
    output reg[31:0] sum;)
    assign sum = operand1+operand2;
endmodule