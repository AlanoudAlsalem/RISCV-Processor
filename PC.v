// The program counter provides the instruction address (readAddress), to the instruction memory.
module PC (
    input address,
    output reg readAddress
);

    always @ (address)
        readAddress = address;

endmodule