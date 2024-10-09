// The program counter provides the instruction address (readAddress), to the instruction memory.
module PC (
    input [31:0] nextAddress,
    output reg [31:0] readAddress
);

    always @ (nextAddress)
        readAddress = nextAddress;

endmodule