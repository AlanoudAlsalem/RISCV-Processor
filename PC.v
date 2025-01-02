// The program counter provides the instruction address (readAddress), to the instruction memory.
module PC(
    input [31:0] nextAddress,
    input clk, reset, nop,
    output reg [31:0] readAddress
);

    always @ (posedge reset or posedge clk) begin
        if(reset)
            readAddress <= 32'b0;
        else if (nop)
            readAddress <= readAddress - 4;
        else begin
                readAddress <= nextAddress;
        end
    end

endmodule