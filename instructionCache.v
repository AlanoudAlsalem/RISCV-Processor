module InstructionCache(
    input reset, clock,
    input [31:0] instructionAddress,
    output reg [31:0] instruction
);

wire [31:0] dataArray [15:0];

// mapping in real time (dividing the instructionAddress into segments)
wire [21:0] tag = instructionAddress[31:12]; //tag = 20 bits 
wire [5:0] index = instructionAddress[11:6]; //index = 6 bits 
wire [3:0] word_offset = instructionAddress[5:2]; //word Offset = 4 bits
wire [1:0] byte_offset = instructionAddress[1:0]; //byte Offset = 2 bits

// data memory arrays
reg [31:0] data_array[63:0][15:0]; //64 blocks, each with 16 words
reg [19:0] tag_array[63:0]; // 20-bit tag array (one tag per block)
reg valid_array[63:0]; //valid bit array (one valid bit per block)

reg [7:0] memory [65535:0]; // 64K memory locations with 8 bits in each location

initial begin 
memory[0]       <= 8'h93;
memory[1]       <= 8'h00;
memory[2]       <= 8'h40;
memory[3]       <= 8'h00;

memory[4]       <= 8'h13;
memory[5]       <= 8'h01;
memory[6]       <= 8'ha0;
memory[7]       <= 8'h00;

memory[8]       <= 8'h93;
memory[9]       <= 8'h01;
memory[10]      <= 8'h90;
memory[11]      <= 8'h00;

memory[12]      <= 8'h63;
memory[13]      <= 8'h82;
memory[14]      <= 8'h20;
memory[15]      <= 8'h00;

memory[16]      <= 8'h63;
memory[17]      <= 8'h82;
memory[18]      <= 8'h30;
memory[19]      <= 8'h00;

memory[20]      <= 8'h63;
memory[21]      <= 8'h02;
memory[22]      <= 8'h31;
memory[23]      <= 8'h00;

memory[24]      <= 8'h63;
memory[25]      <= 8'h82;
memory[26]      <= 8'h20;
memory[27]      <= 8'h00;

memory[28]      <= 8'h93;
memory[29]      <= 8'h02;
memory[30]      <= 8'h10;
memory[31]      <= 8'h00;

memory[32]      <= 8'hff;
memory[33]      <= 8'hff;
memory[34]      <= 8'hff;
memory[35]      <= 8'hff;
end

always @(posedge clock or negedge clock or posedge reset) begin
    if (reset) begin
        //on reset, clear all valid bits
        for (integer i = 0; i < 64; i = i + 1)
            valid_array[i] = 0;
    end
    else begin
        if (~(valid_array[index] && (tag == tag_array[index]))) begin
            data_array[index][0 ]   = {memory[{instructionAddress[31:6], 6'b0} + 3],     memory[{instructionAddress[31:6], 6'b0} + 2],    memory[{instructionAddress[31:6], 6'b0} + 1],    memory[{instructionAddress[31:6], 6'b0}]};
            data_array[index][1 ]   = {memory[{instructionAddress[31:6], 6'b0} + 7],     memory[{instructionAddress[31:6], 6'b0} + 6],    memory[{instructionAddress[31:6], 6'b0} + 5],    memory[{instructionAddress[31:6], 6'b0} + 4]};
            data_array[index][2 ]   = {memory[{instructionAddress[31:6], 6'b0} + 11],    memory[{instructionAddress[31:6], 6'b0} + 10],   memory[{instructionAddress[31:6], 6'b0} + 9],    memory[{instructionAddress[31:6], 6'b0} + 8]};
            data_array[index][3 ]   = {memory[{instructionAddress[31:6], 6'b0} + 15],    memory[{instructionAddress[31:6], 6'b0} + 14],   memory[{instructionAddress[31:6], 6'b0} + 13],   memory[{instructionAddress[31:6], 6'b0} + 12]};
            data_array[index][4 ]   = {memory[{instructionAddress[31:6], 6'b0} + 19],    memory[{instructionAddress[31:6], 6'b0} + 18],   memory[{instructionAddress[31:6], 6'b0} + 17],   memory[{instructionAddress[31:6], 6'b0} + 16]};
            data_array[index][5 ]   = {memory[{instructionAddress[31:6], 6'b0} + 23],    memory[{instructionAddress[31:6], 6'b0} + 22],   memory[{instructionAddress[31:6], 6'b0} + 21],   memory[{instructionAddress[31:6], 6'b0} + 20]};
            data_array[index][6 ]   = {memory[{instructionAddress[31:6], 6'b0} + 27],    memory[{instructionAddress[31:6], 6'b0} + 26],   memory[{instructionAddress[31:6], 6'b0} + 25],   memory[{instructionAddress[31:6], 6'b0} + 24]};
            data_array[index][7 ]   = {memory[{instructionAddress[31:6], 6'b0} + 31],    memory[{instructionAddress[31:6], 6'b0} + 30],   memory[{instructionAddress[31:6], 6'b0} + 29],   memory[{instructionAddress[31:6], 6'b0} + 28]};
            data_array[index][8 ]   = {memory[{instructionAddress[31:6], 6'b0} + 35],    memory[{instructionAddress[31:6], 6'b0} + 34],   memory[{instructionAddress[31:6], 6'b0} + 33],   memory[{instructionAddress[31:6], 6'b0} + 32]};
            data_array[index][9 ]   = {memory[{instructionAddress[31:6], 6'b0} + 39],    memory[{instructionAddress[31:6], 6'b0} + 38],   memory[{instructionAddress[31:6], 6'b0} + 37],   memory[{instructionAddress[31:6], 6'b0} + 36]};
            data_array[index][10]   = {memory[{instructionAddress[31:6], 6'b0} + 43],    memory[{instructionAddress[31:6], 6'b0} + 42],   memory[{instructionAddress[31:6], 6'b0} + 41],   memory[{instructionAddress[31:6], 6'b0} + 40]};
            data_array[index][11]   = {memory[{instructionAddress[31:6], 6'b0} + 47],    memory[{instructionAddress[31:6], 6'b0} + 46],   memory[{instructionAddress[31:6], 6'b0} + 45],   memory[{instructionAddress[31:6], 6'b0} + 44]};
            data_array[index][12]   = {memory[{instructionAddress[31:6], 6'b0} + 51],    memory[{instructionAddress[31:6], 6'b0} + 50],   memory[{instructionAddress[31:6], 6'b0} + 49],   memory[{instructionAddress[31:6], 6'b0} + 48]};
            data_array[index][13]   = {memory[{instructionAddress[31:6], 6'b0} + 55],    memory[{instructionAddress[31:6], 6'b0} + 54],   memory[{instructionAddress[31:6], 6'b0} + 53],   memory[{instructionAddress[31:6], 6'b0} + 52]};
            data_array[index][14]   = {memory[{instructionAddress[31:6], 6'b0} + 59],    memory[{instructionAddress[31:6], 6'b0} + 58],   memory[{instructionAddress[31:6], 6'b0} + 57],   memory[{instructionAddress[31:6], 6'b0} + 56]};
            data_array[index][15]   = {memory[{instructionAddress[31:6], 6'b0} + 63],    memory[{instructionAddress[31:6], 6'b0} + 62],   memory[{instructionAddress[31:6], 6'b0} + 61],   memory[{instructionAddress[31:6], 6'b0} + 60]};
            valid_array[index] = 1;
            tag_array[index] = tag;
        end

        instruction = data_array[index][word_offset];

    end
end

endmodule