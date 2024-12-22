module registerFile(
    input   [4:0]   readReg1,   // 5-bit address of first read register
    input   [4:0]   readReg2,   // 5-bit address of second read register
    input   [4:0]   writeReg,   // 5-bit address of write reg
    input   [31:0]  writeData,  // 32-bit write data
    input           regWrite,   // writing to register file control signal
    input           reset,      // reset signal
    input           clk,
    output  [31:0]  readData1,  // 32-bit read data 1
    output  [31:0]  readData2,  // 32-bit read data 2
    output  [31:0]  r1, r2, r3, r4, r5, r6, r7, r8,
                    r9, r10, r11, r12, r13, r14, r15, r16,
                    r17, r18, r19, r20, r21, r22, r23, r24,
                    r25, r26, r27, r28, r29, r30, r31, r32
);

  reg [31:0] registers [31:0];  // 32 registers with 32 bits in each register

  assign readData1 = registers[readReg1];  // reading data 1
  assign readData2 = registers[readReg2];  // reading data  

  assign r1   = registers[0];     assign r2  = registers[1];
  assign r3   = registers[2];     assign r4  = registers[3];
  assign r5   = registers[4];     assign r6  = registers[5];
  assign r7   = registers[6];     assign r8  = registers[7];
  assign r9   = registers[8];     assign r10 = registers[9];
  assign r11  = registers[10];    assign r12 = registers[11];
  assign r13  = registers[12];    assign r14 = registers[13];
  assign r15  = registers[14];    assign r16 = registers[15];
  assign r17  = registers[16];    assign r18 = registers[17];
  assign r19  = registers[18];    assign r20 = registers[19];
  assign r21  = registers[20];    assign r22 = registers[21];
  assign r23  = registers[22];    assign r24 = registers[23];
  assign r25  = registers[24];    assign r26 = registers[25];
  assign r27  = registers[26];    assign r28 = registers[27]; 
  assign r29  = registers[28];    assign r30 = registers[29];
  assign r31  = registers[30];    assign r32 = registers[31]; 

  always @ (posedge regWrite or writeReg or writeData or reset) begin
    if(reset)
        for(integer i = 0; i < 32; i = i+1)
          registers[i] <= 32'b0; // assigns zero to entire register file
    else if(regWrite)
      if(writeReg != 5'b0) // ensures that x0 stays 0
        registers[writeReg] <= writeData; // writing to register file
  end
  
endmodule