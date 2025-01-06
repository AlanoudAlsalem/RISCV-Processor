// Decides when to branch
module branchUnitPred
# (parameter
    bOp     = 7'h63,
    beqf3   = 3'h0,
    bnef3   = 3'h1,
    jalOp   = 7'h6F,
    jalrOp  = 7'h67
)

(   input clock,
    input [6:0] opCode,
    input [2:0] funct3,
    input [31:0] operand1, operand2,
    output reg PCsrc
);

    // prediction bit. 1 = taken, 0 = not taken
    reg prediction;

    // the default is branch not taken -> PC = PC + 4
    always @ (*) begin
        // static not-taken prediction is used
        prediction <= 1'b0;
        PCsrc =
            (opCode == bOp && funct3 == beqf3 && (operand1 == operand2)) || 
            (opCode == bOp && funct3 == bnef3 && ~(operand1 == operand2)) || 
            (opCode == jalOp) ||
            (opCode == jalrOp);
    end

endmodule