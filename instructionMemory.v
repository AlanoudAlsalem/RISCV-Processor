// The instruction memory receives the address from the PC and outputs the instruction in that address location
module instructionMemory(
    input [31:0] instructionAddress, // 32 bit address
    output [31:0] instruction // 32-bit instructions
);
    reg [7:0] memory [65535:0]; // 64K memory locations with 8 bits in each location
    
    // initializing some instruction in the instruction memory
    initial begin 
       memory[0]       <= 8'h93;
memory[1]       <= 8'h00;
memory[2]       <= 8'h50;
memory[3]       <= 8'h00;

memory[4]       <= 8'h13;
memory[5]       <= 8'h01;
memory[6]       <= 8'h50;
memory[7]       <= 8'h00;

memory[8]       <= 8'h93;
memory[9]       <= 8'h01;
memory[10]      <= 8'ha0;
memory[11]      <= 8'h00;

memory[12]      <= 8'h13;
memory[13]      <= 8'h02;
memory[14]      <= 8'hf0;
memory[15]      <= 8'h00;

memory[16]      <= 8'h63;
memory[17]      <= 8'h82;
memory[18]      <= 8'h20;
memory[19]      <= 8'h00;

memory[20]      <= 8'h93;
memory[21]      <= 8'h02;
memory[22]      <= 8'h10;
memory[23]      <= 8'h00;

memory[24]      <= 8'hff;
memory[25]      <= 8'hff;
memory[26]      <= 8'hff;
memory[27]      <= 8'hff;
    end

    // outputs the instruction from memory (in little endian order)
    assign instruction = {
        memory[instructionAddress + 3], 
        memory[instructionAddress + 2], 
        memory[instructionAddress + 1], 
        memory[instructionAddress]
    };

endmodule