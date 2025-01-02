// The instruction memory receives the address from the PC and outputs the instruction in that address location
module instructionMemory(
    input [31:0] instructionAddress, // 32 bit address
    output [31:0] instruction // 32-bit instructions
);
    reg [7:0] memory [65535:0]; // 64K memory locations with 8 bits in each location
    
    // initializing some instruction in the instruction memory
    initial begin 
        memory[0]   <= 8'h93;
        memory[1]   <= 8'h00;
        memory[2]   <= 8'h40;
        memory[3]   <= 8'h06;
        
        memory[4]   <= 8'h93;
        memory[5]   <= 8'h01;
        memory[6]   <= 8'h00;
        memory[7]   <= 8'h02;
        
        memory[8]   <= 8'h23;
        memory[9]   <= 8'hA0;
        memory[10]  <= 8'h11;
        memory[11]  <= 8'h00;
        
        memory[12]  <= 8'h13;
        memory[13]  <= 8'h01;
        memory[14]  <= 8'h80;
        memory[15]  <= 8'h0C;

        memory[16]  <= 8'h23;
        memory[17]  <= 8'hA4;
        memory[18]  <= 8'h21;
        memory[19]  <= 8'h00;

        memory[20]  <= 8'h03;
        memory[21]  <= 8'h82;
        memory[22]  <= 8'h01;
        memory[23]  <= 8'h00;
        
        memory[24]  <= 8'h83;
        memory[25]  <= 8'h82;
        memory[26]  <= 8'h81;
        memory[27]  <= 8'h00;
        
        memory[28]  <= 8'h13;
        memory[29]  <= 8'h83;
        memory[30]  <= 8'hA2;
        memory[31]  <= 8'h00;

        memory[32]  <= 8'h00;
        memory[33]  <= 8'h00;
        memory[34]  <= 8'h00;
        memory[35]  <= 8'h00;

        memory[36]  <= 8'h00;
        memory[37]  <= 8'h00;
        memory[38]  <= 8'h00;
        memory[39]  <= 8'h00;

        memory[40]  <= 8'h00;
        memory[41]  <= 8'h00;
        memory[42]  <= 8'h00;
        memory[43]  <= 8'h00;

    end

    // outputs the instruction from memory (in little endian order)
    assign instruction = {
        memory[instructionAddress + 3], 
        memory[instructionAddress + 2], 
        memory[instructionAddress + 1], 
        memory[instructionAddress]
    };

endmodule