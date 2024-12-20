// The instruction memory receives the address from the PC and outputs the instruction in that address location
module instructionMemory(
    input [31:0] instructionAddress, // 32 bit address
    output [31:0] instruction // 32-bit instructions
);
    reg [7:0] memory [65535:0]; // 64K memory locations with 8 bits in each location
    
    // initializing some instruction in the instruction memory
    initial begin 
        // addi x1, x0, 1 : 0000 0000 0001 0000 0000 0000 1001 0011
        memory[0]   <= 8'h93;
        memory[1]   <= 8'h00;
        memory[2]   <= 8'h10;
        memory[3]   <= 8'h00;
        // addi x2, x0, 2 : 0000 0000 0002 0000 0000 0001 0001 0011
        memory[4]   <= 8'h13;
        memory[5]   <= 8'h01;
        memory[6]   <= 8'h20;
        memory[7]   <= 8'h00;
        // add x3, x1, x2 : 0100 0000 0001 0001 0001 0001 1011 0011
        memory[8]   <= 8'hB3;
        memory[9]   <= 8'h11;
        memory[10]  <= 8'h11;
        memory[11]  <= 8'h40;

        memory[12]  <= 8'h0;
        memory[13]  <= 8'h0;
        memory[14]  <= 8'h0;
        memory[15]  <= 8'h0;
    end

    // outputs the instruction from memory (in little endian order)
    assign instruction = {
        memory[instructionAddress + 3], 
        memory[instructionAddress + 2], 
        memory[instructionAddress + 1], 
        memory[instructionAddress]
    };

endmodule