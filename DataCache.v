//'include DataMemory.v'

module DataCache(
    input clock,
    input reset,
    input [31:0] address,
    input [31:0] writeData,
    input writeEnable, 
    input writeFromMemory,
    output [31:0] data,
    output hit, stall
);

// mapping addresses in real time (dividing the address into segments)
wire [21:0] tag = address[31:10]; //tag = 22 bits (address[31:10])
wire [3:0] index = address[9:6]; //index = 4 bits (address[9:6])
wire [3:0] word_offset = address[5:2]; //word Offset = 4 bits (address[5:2])
wire [1:0] byte_offset = address[1:0]; //byte Offset = 2 bits (address[1:0])

// data memory arrays
reg [31:0] data_array[15:0][15:0]; //16 blocks, each with 16 words (16x16 array)
reg [21:0] tag_array[15:0]; // 22-bit tag array (one tag per block)
reg valid_array[15:0]; //valid bit array (one valid bit per block)

reg hit_reg;

assign hit_reg = valid_array[index] && (tag == tag_array[index]);

assign hit = hit_reg;
assign data = data_array[index][word_offset];

always @(posedge clock or posedge reset) begin
    stall <= 0;
    if (reset) begin
        //on reset, clear all valid bits
        for (integer i = 0; i < 16; i = i + 1)
            valid_array[i] <= 0;

        hit <= 0;
    end
    else begin
        if(hit_reg) begin
            if (writeEnable) begin 
                // if we want to write data to the cache
                data_array[index][word_offset] = writeData;
            end
        end
        else begin
            stall <= 1;
            // if we are writing from memory
            if (writeFromMemory) begin 
                valid_array[index] <= 1; 
                tag_array[index] <= tag; //update tag for cache 
                data_array[index][word_offset] <= write_data; //write data on appropriate line in cache 
            end    
        end 
    end 
end
endmodule