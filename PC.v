// The program counter provides the instruction address (readAddress), to the instruction memory.
module PC(
    input [31:0] nextAddress,
    input clk, reset,
    output reg [31:0] readAddress
);

    always @ (posedge reset or posedge clk) begin
        if(reset)
            readAddress <= 32'b0;
        else
            readAddress <= nextAddress;
    end

endmodule