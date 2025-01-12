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
    output reg predicted, // 1 = taken 0 = not taken
    output reg [1:0] state // 2-bit state (00 NT | 01 NT | 10 T | 11 T)
);

    // the default is branch not taken -> PC = PC + 4
    always @ (*) begin
        if(reset) begin
            PCsrc <= 0;
            state <=2'b11;
            predicted <=0;
        end
        else if (~nop) begin
            if ((opCode == bOp) && (funct3 == beqf3) && (operand1 == operand2) && clock) 
                PCsrc <= 1; 
            else if ((opCode == bOp) && (funct3 == bnef3) && ~(operand1 == operand2) && clock) 
                PCsrc <= 1;
            else if (opCode == jalOp) 
                PCsrc <= 1;
            else if(opCode == jalrOp) 
                PCsrc <= 1;
            else 
                PCsrc <= 0;
        end // ~nop
        else
            PCsrc <= 0;
    end // always

    always @ (negedge clock)
        PCsrc <= 0;

    always @ (clock) begin
        // branch prediction
        if (opCode == bOp && clock) begin
            case (state)
                2'b00: predicted = 0;
                2'b01: predicted = 0;
                2'b10: predicted = 1;
                2'b11: predicted = 1;
                default: predicted = 0;
            endcase
            case ({state, PCsrc ^ predicted}) // wrong predection if PCsrc and predicted are different (PCsrc XOR predicted = 1)
                {2'b00, 1'b0}: begin
                    predicted = 1'b0;
                end
                {2'b00, 1'b1}: begin
                    predicted = 1'b0;
                    state = 2'b01;
                end
                {2'b01, 1'b0}: begin
                    predicted = 1'b0;
                    state = 2'b00;
                end
                {2'b01, 1'b1}: begin
                    predicted = 1'b0;
                    state = 2'b10;
                end 
                {2'b10, 1'b0}: begin
                    predicted = 1'b1;
                    state = 2'b11;
                end
                {2'b10, 1'b1}: begin
                    predicted = 1'b1;
                    state = 2'b01;
                end
                {2'b11, 1'b0}: begin
                    predicted = 1'b1;
                end
                {2'b11, 1'b1}: begin
                    predicted = 1'b1;
                    state = 2'b10;
                end
                default: predicted = predicted;
            endcase
		end // if
		else if (opCode == jalOp || opCode == jalrOp)
		    predicted = 1'b1; // banch is always taken for jumps
        else
            predicted = 1'b0; // banch is never taken for other instructions   
    end

endmodule