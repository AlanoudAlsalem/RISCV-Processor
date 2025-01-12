// Decides when to branch
`include "branchPredictor.v"
module branchUnitPred
# (parameter
    bOp     = 7'h63,
    beqf3   = 3'h0,
    bnef3   = 3'h1,
    jalOp   = 7'h6F,
    jalrOp  = 7'h67
)

(   input clock, reset, nop,
    input [6:0] opCode,
    input [2:0] funct3,
    input [31:0] operand1, operand2,
    output reg PCsrc,
    output predicted, // 1 = taken 0 = not taken
    output [1:0] state // 2-bit state (00 NT | 01 NT | 10 T | 11 T)
);

    branchPredictor b1(.reset(reset), .PCsrc(PCsrc), .opCode(opCode), .predicted(predicted), .state(state));
    // the default is branch not taken -> PC = PC + 4
    always @ (*) begin
        if(reset) begin
            PCsrc <= 0;
        end
        else if (~nop) begin
            if ((opCode == bOp) && (funct3 == beqf3) && (operand1 == operand2) && clock) begin
                PCsrc <= 1;
            end
            else if ((opCode == bOp) && (funct3 == bnef3) && ~(operand1 == operand2) && clock) begin
                PCsrc <= 1;
            end
            else if (opCode == jalOp) begin
                PCsrc <= 1;
            end
            else if(opCode == jalrOp) begin
                PCsrc <= 1;
            end
            else begin
                PCsrc <= 0;
            end
        end
        else begin
            PCsrc <= 0;
        end
    end

    always @ (negedge clock)
        PCsrc <= 0;

endmodule