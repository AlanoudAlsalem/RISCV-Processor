module DataMemory(DataWrite, DataRead, Address, ReadEnable, WriteEnable, reset);
    input[31:0] DataWrite; //memory address content, from registers 
    input[12:0] Address; //memory address, from ALU
    input ReadEnable; //control signal, read from memory 
    input WriteEnable; //control signal, write to memory 
    output reg [31:0] DataRead; //output of memory address content, read from memory 
    input reset; //active low or high?
    reg [31:0] MemArray[8191:0];  //memory block where data will reside (memory array), 8kx1

    always@(*) begin //do we need to add clk?????
        if(reset == 1) begin
            for(integer i = 0; i<8191; i = i+1)
            MemArray[i] <= 0;
        end
        else begin
            if(WriteEnable == 1) //word write
            MemArray[Address] <= DataWrite;
            if(ReadEnable == 1) //word read
            DataRead <= MemArray[Address][31:0];
        end
    end
endmodule

module testbench();
    reg [31:0]DataWrite;
    reg [12:0]Address; //8192 addresses
    reg ReadEnable;
    reg WriteEnable;
    reg reset;
    wire [31:0]DataRead; //32 bits

    DataMemory inst(.DataWrite(DataWrite), .Address(Address), .ReadEnable(ReadEnable), .WriteEnable(WriteEnable), .reset(reset), .DataRead(DataRead));


    initial begin 

        //initialize variables to zero 
        Address = 0;
        ReadEnable = 0;
        WriteEnable = 0;
        reset = 0;
        DataWrite = 0;
        #20;

        //case 1, write to memory
        Address = 25;
        #10;
        WriteEnable = 1;
        DataWrite = 32'hAAAAAAAA;
        #20;
        $display("Memory contents after writing byte (Address 25): %h", inst.MemArray[25]);
        #10;
        //case 2, read from memory 
        Address = 25;
        ReadEnable = 1;
        WriteEnable = 0;
        reset = 0;
        #20;
        $display("Read byte from address 25: %h", DataRead);

         //case 3, reset 
        Address = 25;
        #10;
        ReadEnable = 1;
        WriteEnable = 0;
        reset = 1;
        #20;
        $display("Memory after reset: ");
        for(integer i = 0; i<63; i = i +1 ) //to check first 64 bits after reset
            $display("Address %d: %h", i, inst.MemArray[i]); //display memory in hex
    end
endmodule