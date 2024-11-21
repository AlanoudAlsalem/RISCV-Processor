// The instruction memory receives the address from the PC and outputs the instruction in that address location
// Assume that the instruction memory has 1024 memory locations
module instructionMemory(
    input [15:0] instructionAddress, //16 bit address for 64K memory locations
    output [31:0] instruction // 32-bit instructions
);
    reg [3:0] memory [65536:0]; // 65536 memory locations with 4 bits in each location
    
    // initializing some instruction in the instruction memory
    initial begin 
        memory[0] = 4'hF;
        memory[1] = 4'hB;
        memory[2] = 4'h0;
        memory[3] = 4'hA;
        
        memory[4] = 4'hF;
        memory[5] = 4'h1;
        memory[6] = 4'h0;
        memory[7] = 4'hC;

        memory[8] = 4'hE;
        memory[9] = 4'h0;
        memory[10] = 4'h1;
        memory[11] = 4'hD;

        memory[12] = 4'hA;
        memory[13] = 4'h1;
        memory[14] = 4'h0;
        memory[15] = 4'h5;
    end

    // outputs the instruction from memory (in little endian order)
    assign instruction = {
        memory[instructionAddress + 3], 
        memory[instructionAddress + 2], 
        memory[instructionAddress + 1], 
        memory[instructionAddress]
    };

endmodule