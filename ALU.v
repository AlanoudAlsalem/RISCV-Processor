// The 32-bit ALU performs computations based on the input operation
module ALU 
# (parameter
    //ALU operations
    addop       = 4'b0001,
    subop       = 4'b0010,
    andop       = 4'b0011,
    orop        = 4'b0100,
    sllop       = 4'b0101,
    srlop       = 4'b0110,
    xorop       = 4'b0111,
    sltop       = 4'b1000,
    jalop       = 4'b1001,
    luiop       = 4'b1010
)

(
    input [3:0] operation, // 4-bit operation
    input [31:0] operand1, // 64-bit operand
    input [31:0] operand2, //64-bit operand
    output reg [31:0] result, // 64-bit result
    output reg zeroFlag // used for branch instructions
);

    always @ (*) begin
        zeroFlag <= 0;
        case(operation)
            addop:  result <= $signed(operand1) + $signed(operand2);
            subop:  result <= $signed(operand1) - $signed(operand2);
            andop:  result <= operand1 & operand2;
            orop:   result <= operand1 | operand2;
            sllop:  result <= operand1 << operand2;
            srlop:  result <= operand1 >> operand2;
            xorop:  result <= operand1 ^ operand2;
            sltop:  result <= (operand1 < operand2) ? 1 : 0;
            jalop:  result <= operand2 + 4;
            luiop:  result <= operand2;
        endcase
        zeroFlag <= (operand1 == operand2) ? 1 : 0;
    end
endmodule