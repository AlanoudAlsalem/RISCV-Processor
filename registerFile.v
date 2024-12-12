module registerFile(
    input   [4:0]   readReg1,   // 5-bit address of first read register
    input   [4:0]   readReg2,   // 5-bit address of second read register
    input   [4:0]   writeReg,   // 5-bit address of write reg
    input   [31:0]  writeData,  // 32-bit write data
    input           regWrite,   // writing to register file control signal
    input           reset,      // reset signal
    output  [31:0]  readData1,  // 32-bit read data 1
    output  [31:0]  readData2   // 32-bit read data 2
);

    reg [31:0] registers [31:0];  // 32 registers with 32 bits in each register

    assign readData1 = registers[readReg1];  // reading data 1
    assign readData2 = registers[readReg2];  // reading data 2
  
  always @ (regWrite or posedge reset)
    begin
      // positive-edge-triggered reset
      if(reset)
        for(integer i =0; i<32; i = i+1)
        registers[i] = 0; // assigns zero to entire register file
      // active high write enable
      else if(regWrite)
        if(writeReg != 5'b0) // ensures that x0 stays 0
          registers[writeReg] = writeData; // writing to register file
    end

endmodule

module testbench();

    reg reset;
    reg [4:0] readReg1, readReg2, writeReg;
    reg regWrite;
    reg [31:0] writeData;
    wire [31:0] readData1, readData2;

    // Instantiate the register file module
    registerFile dut(.reset(reset), .readReg1(readReg1), .readReg2(readReg2), .writeReg(writeReg), .regWrite(regWrite), .writeData(writeData), .readData1(readData1), .readData2(readData2));

    initial begin
        reset = 0;
        readReg1 = 0;
        readReg2 = 1;
        writeReg = 2;
        regWrite = 0;
        writeData = 32'h12345678; // Write data to be stored in register

        // Test case 1: Reset the register file
        #10 reset = 1;  // Assert reset
        #10 reset = 0;  // Deassert reset
        #20 $display("Initial register contents after reset:");
        #20 
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("Register[%d]: %h", i, dut.registers[i]);
        end
        
        // Test case 2: Read Operation (before writing anything)
        #20;
        readReg1 = 5;
        readReg2 = 10;
        #20 $display("Read values at register 5 and 10: %h %h", readData1, readData2);

        // Test Case 3: Write Operation
        #20 writeReg = 5; 
        regWrite = 1;
        writeData = 32'hABCDEF12; // Write new data into register 5
        #20 regWrite = 0; // Disable writing
        #20 $display("Register contents after write:");
        #20 for (integer i = 0; i < 32; i = i + 1) begin
            $display("Register[%d]: %h", i, dut.registers[i]);
        end
        $display("The value written in register 5 is %h", dut.registers[5]);

        // Test case 4: Read Operation (after write)
        #20 readReg1 = 5; readReg2 = 10; 
        #20 $display("Read values after write operation: %h %h", readData1, readData2);

        $finish; // End simulation
    end
endmodule