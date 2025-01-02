//'include DataMemory.v'

module DataCache(
    input clk,
    input reset,
    input [31:0] address,
    input [31:0] writeData,
    input writeEnable, 
    input writeFromMemory,
    output [31:0] data,
    output hit
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

always @(posedge clk or posedge reset) begin
    if (reset) begin
        //on reset, clear all valid bits
        for (integer i = 0; i < 16; i = i + 1)
            valid_array[i] <= 0;

        hit <= 0;
    end
    else 
        // if we are writing from memory
        if (writeFromMemory) begin 
            valid_array[index] <= 1; 
            tag_array[index] <= tag; //update tag for cache 
            data_array[index][word_offset] <= write_data; //write data on appropriate line in cache 
        end 

        if (writeEnable) begin 
            // if we want to write data to the cache
            if (hit_reg)
                data_array[index][word_offset] = writeData;
    end
    
    
end
endmodule



module DataCache_tb;

//declare inputs as reg and outputs as wire
reg clk;
reg reset;
reg [31:0] address;
reg [31:0] write_data;
reg write_enable;
reg read_enable;
wire [31:0] read_data;
wire hit;

//instantiate the DataCache module
DataCache DCInstant(.clk(clk), .address(address), .reset(reset), .write_data(write_data), .write_enable(write_enable), .read_enable(read_enable), .read_data(read_data), .hit(hit));

//clock generation
always begin
    clk = ~clk;
    #5;  //period = 10 units (50MHz clock)
end

//stimulus
initial begin
    //initialize inputs
    clk = 0;
    reset = 0;
    address = 32'b0;
    write_data = 32'b0;
    write_enable = 0;
    read_enable = 0;

    //apply reset
    $display("Applying reset");
    reset = 1;
    #10;
    reset = 0;
    
    //test Case 1: Cache Miss
    #10;
    $display("Test Case 1: Cache Miss");
    address = 32'h00000010; //adress mapped to index 0, tag 0x000004
    read_enable = 1;
    #20; //wait for cache to process the read operation
    $display("Read Data: %h, Hit: %b", read_data, hit); //expected read_data = 0, hit = 0

    //test Case 2: Cache Write (write_enable = 1)
    #10;
    $display("Test Case 2: Cache Write");
    address = 32'h00000010; //address mapped to index 0, tag 0x000004
    write_data = 32'h12345678;
    write_enable = 1;
    #20; //wait for cache to process the write operation
    write_enable = 0;
    #10; //wait after write operation
    
    //test Case 3: Cache Hit
    #10;
    $display("Test Case 3: Cache Hit");
    address = 32'h00000010; //same address as Test Case 2 (same tag)
    read_enable = 1;
    #20; //wait for cache to process the read operation
    $display("Read Data: %h, Hit: %b", read_data, hit); //expected read_data = 0x12345678, hit = 1

    #20;

    //test Case 4: Cache Miss (Different Address)
    #10;
    $display("Test Case 4: Cache Miss");
    address = 32'h00000020; //address mapped to a different index (index 1)
    read_enable = 1;
    #20; //wait for cache to process the read operation
    $display("Read Data: %h, Hit: %b", read_data, hit); //expected read_data = 0, hit = 0

    #100;

    //test Case 5: Reset the cache and check if values reset
    #10;
    $display("Test Case 5: Reset Cache");
    reset = 1;
    #20; //wait for reset to propagate
    reset = 0;
    #10; //wait after reset
    address = 32'h00000010;
    read_enable = 1;
    #20; //wait for cache to process the read operation after reset
    $display("Read Data: %h, Hit: %b", read_data, hit); //expected read_data = 0, hit = 0

    $finish; //end simulation
end

endmodule


