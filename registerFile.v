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

    assign readData1 = file[readReg1];  // reading data 1
    assign readData2 = file[readReg2];  // reading data 2
  
  always @ (regWrite or posedge reset)
    begin
      // positive-edge-triggered reset
      if(reset)
        registers = 'b0; // assigns zero to entire register file
      // active high write enable
      else if(regWrite)
        if(writeReg != 5'b0) // ensures that x0 stays 0
          registers[writeReg] = writeData; // writing to register file
    end

endmodule