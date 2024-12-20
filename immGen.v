// The immediate generator sign extends the input to 32 bits
module immGen
# (parameter
    // opCodes 
    // I-types        
    addiwOp     = 7'h13,
    andiOp      = 7'h1B,
    jalrOp      = 7'h67,
    lhOp        = 7'h03,
    lwOp        = 7'h03,
    oriOp       = 7'h13,
               
    beqOp       = 7'h63,
    bneOp       = 7'h63,
    jalOp       = 7'h6F,
    luiOp       = 7'h38,
    sbOp        = 7'h23,
    swOp        = 7'h23
)

(   input [31:0] instruction,
    output reg [31:0] out
);

    always @ (*) begin
        case (instruction[6:0])
            // I-types
            addiwOp:    out <= {{20{instruction[31]}}, instruction[31:20]}; // same for addiw and ori
            andiOp:     out <= {{20{instruction[31]}}, instruction[31:20]};
            jalrOp:     out <= {{20{instruction[31]}}, instruction[31:20]};
            lwOp:       out <= {{20{instruction[31]}}, instruction[31:20]}; // same for lw and lh
            beqOp:      out <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // same for beq and bne
            jalOp:      out <= {{12{instruction[31]}}, instruction[31:12]};
            luiOp:      out <= {12'b0, instruction[31:12]};
            swOp:       out <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // same for sw and and sb
        endcase 
    end
endmodule