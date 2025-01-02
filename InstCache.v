module InstCache(
    input clk;
    input reset;
    input [31:0] address;
    input [31:0] write_data;
    input write_enable;
    input read_enable;
    output reg [31:0] read_data;
    output reg hit;
);

//initialization of instmem arrays 
reg [63:0] inst_data[63:0][19:0]; //data storage
reg [21:0] inst_tags[63:0]; //tags
reg valid_array[63:0]; //valid bits

//instantiate instruction memory module
wire [63:0] InstMemData; //output from instruction memory
instructionMemory InstMem(.instructionAddress(address), .instruction(InstMemData));
reg [63:0] memory[1023:0]; // A small block of lower memory for testing

//buffers
reg write_instructionMemory; // A signal to indicate writing to instruction memory
reg [31:0] WriteBufferData; //temporarily write data on buffer
reg [31:0] ReadBufferData; //read buffer to temporarily store data
reg BufferFlag;

//mapping addresses in real time (dividing the address into segments)
wire [19:0] tag = address[31:12]; //tag = 20 bits (address[31:12])
wire [5:0] index = address[11:6]; //index = 6 bits (address[11:6])
wire [3:0] word_offset = address[5:2]; //word Offset = 4 bits (address[5:2])
wire [1:0] byte_offset = address[1:0]; //byte Offset = 2 bits (address[1:0])
//saving valid and tag in temps because verilog doesnt support directly reading from a 2D array
reg [63:0] temp_data;
reg [19:0] temp_tag;
reg temp_valid;

always @(posedge clk or posedge reset)
begin
    if (reset)  // In case of reset, clear all 
    begin
        for (integer i = 0; i < 64; i = i+1)
        begin
            valid_array[i] <= 0; 
            inst_tags[i] <= 0;
        end
        hit <= 0;
        read_data <= 32'b0;  // Fill all data with zeros
        WriteBufferData <= 32'b0;
        ReadBufferData <= 32'b0;
        BufferFlag <= 0;
    end    
    else if (read_enable)
    begin
        // Read the cache
        temp_valid <= valid_array[index];  // Read the valid bit
        temp_tag <= inst_tags[index];  // Read the tag
        
        if (temp_valid && temp_tag == tag) 
        begin
            // Cache hit, read data from the corresponding block
            hit <= 1;
            temp_data <= inst_data[index][word_offset];  // Select the correct word from the block
            ReadBufferData <= temp_data[31:0];  // Store data in the read buffer
            read_data <= ReadBufferData;
        end
        else
        begin
            // Cache miss, load from instruction memory
            hit <= 0;
            temp_data <= InstMemData;  // Fetch from instruction memory
            inst_data[index][word_offset] <= InstMemData;  // Store fetched data in cache
            inst_tags[index] <= tag;  // Update the tag
            valid_array[index] <= 1;  // Mark this cache line as valid
            ReadBufferData <= InstMemData[31:0];  // Store in the read buffer
            read_data <= ReadBufferData;
        end
    end
    else if (write_enable) 
    begin
        // Write to the cache
        hit <= 0;  // Write is not a cache hit, set hit to 0
        valid_array[index] <= 1;  // Set the valid bit
        inst_tags[index] <= tag;  // Update the tag
        inst_data[index][word_offset] <= write_data;  // Write data to cache

        // Write through to memory immediately
        memory[address[31:2]] <= write_data;  // Write to simulated lower-level memory
        write_instructionMemory <= 1;  // Write to instruction memory
        WriteBufferData <= write_data;
    end
    else if (BufferFlag)
    begin
        BufferFlag <= 0;  // Empty the buffer when the write operation is complete
    end
end


endmodule


module InstCache_tb;

// Declare inputs as reg and outputs as wire
reg clk;
reg reset;
reg [31:0] address;
reg [31:0] write_data;
reg write_enable;
reg read_enable;
wire [31:0] read_data;
wire hit;

// Instantiate the InstCache module
InstCache IDInstant (.clk(clk), .address(address), .reset(reset), .write_data(write_data), .write_enable(write_enable), .read_enable(read_enable), .read_data(read_data), .hit(hit));

// Clock generation
always begin
    #5 clk = ~clk; // Clock with a period of 10 time units (50 MHz)
end

// Stimulus generation
initial 
begin
    // Initialize inputs
    clk = 0;
    reset = 0;
    address = 32'b0;
    write_data = 32'b0;
    write_enable = 0;
    read_enable = 0;

    // Apply reset
    #10;
    $display("Applying reset");
    reset = 1;
    #20;
    reset = 0;
    #10;

    // Test Case 1: Cache Miss
    #10;
    $display("Test Case 1: Cache Miss");
    address = 32'h00000010; // Address mapped to index 0, tag 0x000004
    read_enable = 1;
    #20;
    $display("Read Data: %h, Hit: %b", read_data, hit); // Expected read_data = 0, hit = 0

    // Test Case 2: Cache Write
    #10;
    $display("Test Case 2: Cache Write");
    address = 32'h00000010; // Address mapped to index 0, tag 0x000004
    write_data = 32'h12345678;
    write_enable = 1;
    #20;
    write_enable = 0;
    #10;

    // Test Case 3: Cache Hit
    #10;
    $display("Test Case 3: Cache Hit");
    address = 32'h00000010; // Same address as Test Case 2 (same tag)
    read_enable = 1;
    #20; // Wait for cache to process the read operation
    $display("Read Data: %h, Hit: %b", read_data, hit); // Expected read_data = 0x12345678, hit = 1

    // Test Case 4: Cache Miss (Different Address)
    #10;
    $display("Test Case 4: Cache Miss");
    address = 32'h00000020; // Address mapped to a different index (index 1)
    read_enable = 1;
    #20; // Wait for cache to process the read operation
    $display("Read Data: %h, Hit: %b", read_data, hit); // Expected read_data = 0, hit = 0

    // Test Case 5: Reset the cache and check if values reset
    #10;
    $display("Test Case 5: Reset Cache");
    reset = 1;
    #20; // Wait for reset to propagate
    reset = 0;
    #10;
    address = 32'h00000010;
    read_enable = 1;
    #20; // Wait for cache to process the read operation after reset
    $display("Read Data: %h, Hit: %b", read_data, hit); // Expected read_data = 0, hit = 0
    #10;

    $finish; // End simulation
end

endmodule
