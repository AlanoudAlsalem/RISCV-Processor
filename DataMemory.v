module DataMemory(DataIn, DataOut, Address, ReadEnable, WriteEnable, clk);
    input[31:0] DataIn; //memory address content, change size 
    input[31:0] Address; //memory address, change address size as required 
    input ReadEnable;
    input WriteEnable;
    output reg [31:0] DataOut; //output of memory address content
    //do we need reset and why
    reg [31:0] MemArray[0:255];  // memory block where data will reside (memory array)

    integer i;

    initial begin
    DataOut <= 0; //initialize read data to zero
        for (i = 0; i < 256; i = i + 1) begin
    mem[i] = i;
    end
end

always @(posedge clk) begin 
    if(WriteEnable == 1'b1) begin //if writing onto memory 
        MemArray[Address] = DataIn;
    end
    else if(ReadEnable == 1'b1) begin //if reading from memory 
        DataOut == MemArray[Address];
    end
end 
endmodule


module MemTestbench();
    reg clk;
    reg WriteEnable;
    reg ReadEnable;
    reg[31:0] DataIn;
    wire[31:0] DataOut;
    reg[31:0] Address; 

//instantiate and map
DataMemory inst(clk(clk), WriteEnable(WriteEnable), ReadEnable(ReadEnable), DataIn(DataIn), DataOut(DataOut), Address(Address));

always #5 clk = ~clk;

initial begin
    clk = 0;
    Address = 0;
    WriteEnable = 0;
    ReadEnable = 0;
    DataIn = 0;

    #20 //wait for conditions to apply

    //Write to memory 
    Address =  32'd10;
    WriteEnable = 1'b1;
    ReadEnable = 1'b0;
    DataIn = 32'hDEADBEEF;

    #20;

    $display("Memory content after storing: %h", inst.MemArray[32'd10]);

    //Read from memory
    Address =  32'd10;
    WriteEnable = 1'b0;
    ReadEnable = 1'b1;

   // Check the output
    if (DataOut != 32'hDEADBEEF) begin
    $display("Test failed: Expected 0xDEADBEEF, got 0x%h", DataOut);
    end 
    else begin
    $display("Test passed: Read 0x%h from address 10", DataOut);
    end

    $finish
end
endmodule
