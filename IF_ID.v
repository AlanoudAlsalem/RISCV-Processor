module IF_ID(
    input clock, reset, jalr,
    input [31:0] PC_in, instruction_in, 
    output reg [31:0] PC, instruction
);

    always @ (posedge clock or posedge reset) begin
        if (reset || jalr) begin
            PC          <= 0;
            instruction <= 0;
        end
        else begin
            PC          <= PC_in;
            instruction <= instruction_in;
        end
    end

endmodule