module DataCache(
    input reset, sb, clock,
    input [31:0] address,
    input [31:0] writeData,
    input writeEnable, 
    output reg [31:0] data,
    output [31:0] m0,   m4,     m8,     m12,    m16,     
                  m20,  m24,    m28,    m32,    m36,
    output [31:0] c0 ,c1 ,c2 ,c3 ,c4 ,c5 ,c6 ,c7 ,c8 ,c9 ,c10,c11,c12,c13,c14,c15
);

wire [31:0] dataArray [15:0];

// mapping addresses in real time (dividing the address into segments)
wire [21:0] tag = address[31:10]; //tag = 22 bits (address[31:10])
wire [3:0] index = address[9:6]; //index = 4 bits (address[9:6])
wire [3:0] word_offset = address[5:2]; //word Offset = 4 bits (address[5:2])
wire [1:0] byte_offset = address[1:0]; //byte Offset = 2 bits (address[1:0])

// data memory arrays
reg [31:0] data_array[15:0][15:0]; //16 blocks, each with 16 words (16x16 array)
reg [21:0] tag_array[15:0]; // 22-bit tag array (one tag per block)
reg valid_array[15:0]; //valid bit array (one valid bit per block)


// initializing data
    initial begin 
        memory[0]   <= 8'h0;
        memory[1]   <= 8'h0;
        memory[2]   <= 8'h0;
        memory[3]   <= 8'h0;

        memory[4]   <= 8'hAA;
        memory[5]   <= 8'h0B;
        memory[6]   <= 8'hCC;
        memory[7]   <= 8'h0D;

        memory[8]   <= 8'h0;
        memory[9]   <= 8'h0;
        memory[10]  <= 8'h0;
        memory[11]  <= 8'h0;

        memory[12]  <= 8'h0;
        memory[13]  <= 8'h0;
        memory[14]  <= 8'h0;
        memory[15]  <= 8'h0;

        memory[16]  <= 8'h0;
        memory[17]  <= 8'h0;
        memory[18]  <= 8'h0;
        memory[19]  <= 8'h0;

        memory[20]  <= 8'h0;
        memory[21]  <= 8'h0;
        memory[22]  <= 8'h0;
        memory[23]  <= 8'h0;

        memory[24]  <= 8'h0;
        memory[25]  <= 8'h0;
        memory[26]  <= 8'h0;
        memory[27]  <= 8'h0;

        memory[28]  <= 8'h0;
        memory[29]  <= 8'h0;
        memory[30]  <= 8'h0;
        memory[31]  <= 8'h0;

        memory[32]  <= 8'h00;
        memory[33]  <= 8'h0;
        memory[34]  <= 8'h0;
        memory[35]  <= 8'h0;

        memory[36]  <= 8'h0;
        memory[37]  <= 8'h0;
        memory[38]  <= 8'h0;
        memory[39]  <= 8'h0;
    end

    reg [7:0] memory [8191:0]; // 8K memory locations with 8 bits in each location (data memory)

    assign m0   = {memory[3],     memory[2],      memory[1],      memory[0]};
    assign m4   = {memory[7],     memory[6],      memory[5],      memory[4]};
    assign m8   = {memory[11],    memory[10],     memory[9],      memory[8]};
    assign m12  = {memory[15],    memory[14],     memory[13],     memory[12]};
    assign m16  = {memory[19],    memory[18],     memory[17],     memory[16]};
    assign m20  = {memory[23],    memory[22],     memory[21],     memory[20]};
    assign m24  = {memory[27],    memory[26],     memory[25],     memory[24]};
    assign m28  = {memory[31],    memory[30],     memory[29],     memory[28]};
    assign m32  = {memory[35],    memory[34],     memory[33],     memory[32]};
    assign m36  = {memory[39],    memory[38],     memory[37],     memory[36]};


    assign c0  = data_array[0][0];
    assign c1  = data_array[0][1];
    assign c2  = data_array[0][2];
    assign c3  = data_array[0][3];
    assign c4  = data_array[0][4];
    assign c5  = data_array[0][5];
    assign c6  = data_array[0][6];
    assign c7  = data_array[0][7];
    assign c8  = data_array[0][8];
    assign c9  = data_array[0][9];
    assign c10  = data_array[0][10];
    assign c11  = data_array[0][11];
    assign c12  = data_array[0][12];
    assign c13  = data_array[0][13];
    assign c14  = data_array[0][14];
    assign c15  = data_array[0][15];


always @(clock or posedge reset) begin
    if (reset) begin
        //on reset, clear all valid bits
        for (integer i = 0; i < 16; i = i + 1)
            valid_array[i] = 0;
    end
    else begin
        if (~(valid_array[index] && (tag == tag_array[index]))) begin
            data_array[index][0 ]   = {memory[{address[31:6], 6'b0} + 3],     memory[{address[31:6], 6'b0} + 2],    memory[{address[31:6], 6'b0} + 1],    memory[{address[31:6], 6'b0}]};
            data_array[index][1 ]   = {memory[{address[31:6], 6'b0} + 7],     memory[{address[31:6], 6'b0} + 6],    memory[{address[31:6], 6'b0} + 5],    memory[{address[31:6], 6'b0} + 4]};
            data_array[index][2 ]   = {memory[{address[31:6], 6'b0} + 11],    memory[{address[31:6], 6'b0} + 10],   memory[{address[31:6], 6'b0} + 9],    memory[{address[31:6], 6'b0} + 8]};
            data_array[index][3 ]   = {memory[{address[31:6], 6'b0} + 15],    memory[{address[31:6], 6'b0} + 14],   memory[{address[31:6], 6'b0} + 13],   memory[{address[31:6], 6'b0} + 12]};
            data_array[index][4 ]   = {memory[{address[31:6], 6'b0} + 19],    memory[{address[31:6], 6'b0} + 18],   memory[{address[31:6], 6'b0} + 17],   memory[{address[31:6], 6'b0} + 16]};
            data_array[index][5 ]   = {memory[{address[31:6], 6'b0} + 23],    memory[{address[31:6], 6'b0} + 22],   memory[{address[31:6], 6'b0} + 21],   memory[{address[31:6], 6'b0} + 20]};
            data_array[index][6 ]   = {memory[{address[31:6], 6'b0} + 27],    memory[{address[31:6], 6'b0} + 26],   memory[{address[31:6], 6'b0} + 25],   memory[{address[31:6], 6'b0} + 24]};
            data_array[index][7 ]   = {memory[{address[31:6], 6'b0} + 31],    memory[{address[31:6], 6'b0} + 30],   memory[{address[31:6], 6'b0} + 29],   memory[{address[31:6], 6'b0} + 28]};
            data_array[index][8 ]   = {memory[{address[31:6], 6'b0} + 35],    memory[{address[31:6], 6'b0} + 34],   memory[{address[31:6], 6'b0} + 33],   memory[{address[31:6], 6'b0} + 32]};
            data_array[index][9 ]   = {memory[{address[31:6], 6'b0} + 39],    memory[{address[31:6], 6'b0} + 38],   memory[{address[31:6], 6'b0} + 37],   memory[{address[31:6], 6'b0} + 36]};
            data_array[index][10]   = {memory[{address[31:6], 6'b0} + 43],    memory[{address[31:6], 6'b0} + 42],   memory[{address[31:6], 6'b0} + 41],   memory[{address[31:6], 6'b0} + 40]};
            data_array[index][11]   = {memory[{address[31:6], 6'b0} + 47],    memory[{address[31:6], 6'b0} + 46],   memory[{address[31:6], 6'b0} + 45],   memory[{address[31:6], 6'b0} + 44]};
            data_array[index][12]   = {memory[{address[31:6], 6'b0} + 51],    memory[{address[31:6], 6'b0} + 50],   memory[{address[31:6], 6'b0} + 49],   memory[{address[31:6], 6'b0} + 48]};
            data_array[index][13]   = {memory[{address[31:6], 6'b0} + 55],    memory[{address[31:6], 6'b0} + 54],   memory[{address[31:6], 6'b0} + 53],   memory[{address[31:6], 6'b0} + 52]};
            data_array[index][14]   = {memory[{address[31:6], 6'b0} + 59],    memory[{address[31:6], 6'b0} + 58],   memory[{address[31:6], 6'b0} + 57],   memory[{address[31:6], 6'b0} + 56]};
            data_array[index][15]   = {memory[{address[31:6], 6'b0} + 63],    memory[{address[31:6], 6'b0} + 62],   memory[{address[31:6], 6'b0} + 61],   memory[{address[31:6], 6'b0} + 60]};
            valid_array[index] = 1;
            tag_array[index] = tag;
        end

        if(writeEnable) begin
            // write-through
            if(sb) begin
                memory[address] <= writeData[7:0];
                data_array[index][word_offset][7:0] <= writeData;
            end
            else begin // stores the data in little endian format
                memory[address]     <= writeData[7:0];
                memory[address + 1] <= writeData[15:8];
                memory[address + 2] <= writeData[23:16];
                memory[address + 3] <= writeData[31:24];

                data_array[index][word_offset] <= writeData;
            end   
        end

        data = data_array[index][word_offset];

    end
end

endmodule