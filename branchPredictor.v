
module branchPredictor
# (parameter
    bOp     = 7'h63,
    jalOp   = 7'h6F,
    jalrOp  = 7'h67
)

(   input reset, PCsrc,
    input [6:0] opCode,
    output reg predicted, // 1 = taken 0 = not taken
    output reg [1:0] state // 2-bit state (00 NT | 01 NT | 10 T | 11 T)
);
	
	// branch predictor
    always @ (reset or opCode or PCsrc) begin
		// active high reset to 00
		if (reset) begin
			state <= 2'b0;
			predicted <= 1'b0;
		end
		else if (opCode == bOp) begin
			case ({state, PCsrc ^ predicted}) // wrong predection if PCsrc and predicted are different (PCsrc XOR predicted = 1)
				{2'b00, 1'b0}: begin
					predicted <= 1'b0;
				end
				{2'b00, 1'b1}: begin
					predicted <= 1'b0;
					state <= 2'b01;
				end
				{2'b01, 1'b0}: begin
					predicted <= 1'b0;
					state <= 2'b00;
				end
				{2'b01, 1'b1}: begin
					predicted <= 1'b0;
					state <= 2'b10;
				end 
				{2'b10, 1'b0}: begin
					predicted <= 1'b1;
					state <= 2'b11;
				end
				{2'b10, 1'b1}: begin
					predicted <= 1'b1;
					state <= 2'b01;
				end
				{2'b11, 1'b0}: begin
					predicted <= 1'b1;
				end
				{2'b11, 1'b1}: begin
					predicted <= 1'b1;
					state <= 2'b10;
				end
                default: predicted <= predicted;
			endcase
		end
		else if (opCode == jalOp || opCode == jalrOp)
			predicted = 1'b1; // banch is always taken for jumps
        else
            predicted = 1'b0; // banch is never taken for other instructions
	end
endmodule