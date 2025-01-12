// The program counter provides the instruction address (readAddress), to the instruction memory.
module PC(
    input [31:0] nextAddress, immediate,
    input clock, reset, nop, branch,
    output reg [31:0] readAddress
);

    always @ (posedge reset or posedge clock) begin
        if(reset)
            readAddress <= 32'b0;
        else begin 
            readAddress <= nextAddress;
        end
    end

    // By the time the negative edge arrives:
    // 1. The branchUnit would have produced its branch output
    // 2. The forwarding unit would have produced the nop signal
    // Using the negative edge allows for determining the PC value in the same cycle the signals are produced
    always @ (negedge clock) begin
        if (nop) begin
            readAddress <= readAddress - 4;
        end
        else if(branch) begin
            readAddress <= nextAddress;
        end
    end
endmodule