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
memory[2]       <= 8'h00;
memory[3]       <= 8'h02;

memory[4]       <= 8'h13;
memory[5]       <= 8'h01;
memory[6]       <= 8'h80;
memory[7]       <= 8'hff;

memory[8]       <= 8'hb3;
memory[9]       <= 8'h91;
memory[10]      <= 8'h20;
memory[11]      <= 8'h40;

memory[12]      <= 8'h33;
memory[13]      <= 8'h92;
memory[14]      <= 8'h31;
memory[15]      <= 8'h40;

memory[16]      <= 8'hb3;
memory[17]      <= 8'h62;
memory[18]      <= 8'h32;
memory[19]      <= 8'h00;

memory[20]      <= 8'h23;
memory[21]      <= 8'hae;
memory[22]      <= 8'h52;
memory[23]      <= 8'hfe;

memory[24]      <= 8'h03;
memory[25]      <= 8'h83;
memory[26]      <= 8'hc1;
memory[27]      <= 8'hff;

memory[28]      <= 8'h23;
memory[29]      <= 8'h26;
memory[30]      <= 8'h63;
memory[31]      <= 8'hfe;

memory[32]      <= 8'h83;
memory[33]      <= 8'h03;
memory[34]      <= 8'h83;
memory[35]      <= 8'h00;

memory[36]      <= 8'h33;
memory[37]      <= 8'h94;
memory[38]      <= 8'h33;
memory[39]      <= 8'h40;

memory[40]      <= 8'h33;
memory[41]      <= 8'h14;
memory[42]      <= 8'h32;
memory[43]      <= 8'h40;

memory[44]      <= 8'hb3;
memory[45]      <= 8'h14;
memory[46]      <= 8'h04;
memory[47]      <= 8'h40;

memory[48]      <= 8'h33;
memory[49]      <= 8'h90;
memory[50]      <= 8'h84;
memory[51]      <= 8'h40;

memory[52]      <= 8'hff;
memory[53]      <= 8'hff;
memory[54]      <= 8'hff;
memory[55]      <= 8'hff;
    end

    // outputs the instruction from memory (in little endian order)
    assign instruction = {
        memory[instructionAddress + 3], 
        memory[instructionAddress + 2], 
        memory[instructionAddress + 1], 
        memory[instructionAddress]
    };

endmodule