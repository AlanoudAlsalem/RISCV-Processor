// The program counter provides the instruction address (readAddress), to the instruction memory.
module PC(
    input [31:0] nextAddress,
    output reg [31:0] readAddress
);

    always @ (nextAddress)
        readAddress = nextAddress;

endmodule // PC

module PC_testbench;
    reg [31:0] nextAddress;
    wire [31:0] readAddress;

    PC DUT(
        .nextAddress(nextAddress),
        .readAddress(readAddress)
    );

    initial begin
        nextAddress = 32'b0;
        #1
        $display("Next Address = %d Read Address = %d", nextAddress, readAddress);
    end

endmodule // testbench