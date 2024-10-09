// The instruction memory receives the address from the PC and outputs the instruction in that address location
// Assume that the instruction memory has 1024 memory locations
module instructionMemory(
    input [9:0] instructionAddress, //10 bit address for 1024 memory locations
    output [63:0] instruction // 64-bit instructions
);
    reg [63:0] memory [1023:0]; // 1024 memory locations with 64 bits in each location
    
    initial begin 
        memory[0] = 64'b001;
        memory[10] = -64'b00010;
        memory[1023] = 64'b001001;
    end

    assign instruction = memory[instructionAddress]; // outputs the instruction from memory

endmodule