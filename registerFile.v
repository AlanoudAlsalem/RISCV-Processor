module registerFile(
    input [4:0] readReg1, // address of first read register
    input [4:0] readReg2, // address of second read register
    input [4:0] writeReg, // address of write reg
    input [63:0] writeData, // write data
    input regWrite, // control signal
    output [63:0] readData1, // read data 1
    output [63:0] readData2 // read data 2
);

    reg [31:0] registers [63:0]; // register file
  
  always @ (*)
    begin 
      if(writeReg)
        registers[writeReg] = writeData; //writing to register file
      
      readData1 = file[readReg1]; // reading data 1
      readData2 = file[readReg2]; // reading data 2
    end

endmodule