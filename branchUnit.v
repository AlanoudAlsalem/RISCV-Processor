// Decides when to branch
module branchUnit
# (parameter
    beqSig  = 2'b01,
    bneSig  = 2'b10,
    jSig    = 2'b11,
    bOp   = 7'h63
)

(   input [1:0] branch,
    input zeroFlag,
    output PCsrc 
);

    assign PCsrc = ((branch == beqSig && zeroFlag) || (branch == bneSig && ~zeroFlag) || branch == jSig) ? 1 : 0;

endmodule