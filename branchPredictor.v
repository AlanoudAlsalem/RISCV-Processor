module branchPredictor(
    input [6:0] ID_opcode, EX_opcode;
	input reset, wrongPrediction, clock,
    output predicted // 1 = taken 0 = not taken
);

    reg [1:0] state; // 2-bit state (00 NT | 01 NT | 10 T | 11 T)

    always @ (posedge reset or posedge clk) begin
		// active high reset to 00
		if (reset) begin
			state <= 2'b0;
			predicted <= 1'b0;
		end
		else if (opcode == beq || opcode == bne) begin
			case ({state, Wrong_prediction}) 
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
			endcase
		end
		else 
			predicted = 1'b0;
	end

endmodule