// The 64-bit ALU performs computations based on the input operation

module ALU(
    input [3:0] operation, // 4-bit operation
    input [63:0] operand1, // 64-bit operand
    input [63:0] operand2, //64-bit operand
    output reg [63:0] result, // 64-bit result
    output reg zeroFlag // used for branch instructions
);

    parameter 
     4'b0000 = add,
     4'b0001 = sub,
     4'b0010 = mul,
     4'b0011 = div,
     4'b0100 = shiftLeft,
     4'b0101 = shiftRight;

     always @ (*) begin
        case(operation)
            add: result = operand1 + operand2;
            sub: result = operand1 - operand2;
            mul: result = operand1 * operand2;
            div: result = operand1 / operand2;
            shiftLeft: result = operand1 <<< operand2;
            shiftRight: result = operand1 >>> operand2;
        endcase
        operation = sub ? (result == 0 ? zeroFlag = 1 : zeroFlag = 0) : zeroFlag = 0;
     end

endmodule