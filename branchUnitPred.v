// Decides when to branch
module branchUnitPred
# (parameter
    bOp     = 7'h63,
    beqf3   = 3'h0,
    bnef3   = 3'h1,
    jalOp   = 7'h6F,
    jalrOp  = 7'h67
)

(   input reset,
    input [6:0] opCode,
    input [2:0] funct3,
    input [31:0] operand1, operand2,
    output reg PCsrc
);

    // the default is branch not taken -> PC = PC + 4
    always @ (operand1 or operand2) begin
        if (reset)
            PCsrc <= 0;
        else
            PCsrc <=
                (opCode == bOp && funct3 == beqf3 && (operand1 == operand2)) || 
                (opCode == bOp && funct3 == bnef3 && ~(operand1 == operand2)) || 
                (opCode == jalOp) ||
                (opCode == jalrOp);
    end

endmodule