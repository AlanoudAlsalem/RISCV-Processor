// CPU connections between modules
`include "PC.v"
`include "instructionMemory.v"
`include "registerFile.v"
`include "controlUnit.v"
// `include "mux2_1.v"
// `include "immGen.v"
// `include "CPU.v"
// `include "adder.v"
// `include "ALU.v" 

module CPU(
    input [31:0] address,
    // pc output
    output [31:0] pcOut,
    // instruction memory output
    output [31:0] instructionMemoryOut,
    // register file output
    output [31:0] registerRead1,
    output [31:0] registerRead2,
    // control unit outputs
    output regWriteSignal,
    output memWriteSignal,
    output [2:0] aluOPout,
    output [31:0] out
);

    reg reset = 0;

    ////////////////////    IF STAGE    ////////////////////

    // connects the output of the PC to the input of the instruction memory
    wire [31:0] nextAddress;

    PC DUT(
        .nextAddress(address), 
        .readAddress(nextAddress)
    );

    // testing output
    assign pcOut = nextAddress;


    // bus of the 32-bit instruction
    wire [31:0] instruction;

    instructionMemory DUT(
        .instructionAddress(nextAddress), 
        .instruction(instruction)
    );
    
    //testing output
    assign instructionMemoryOut = instrucion;

    ////////////////////    ID STAGE    ////////////////////

    // resulting control unit signals
    wire regWrite, memWrite, ALUop;

    controlUnit DUT(
        .opCode(instruction[6:0]), 
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .regWrite(regWrite), 
        .memWrite(memWrite), 
        .ALUop(ALUop)
    );

    // testing outputs
    assign regWriteSignal = regWrite;
    assign memWriteSignal = memWrite;
    assign aluOPout = ALUop;

    // data read from register file
    wire [31:0] readData1, readData2;

    registerFile DUT(
        .readReg1(instruction[19:15]),
        .readReg2(instrucion[24:20]),
        .writeReg([11:7]),
        .writeData(32'd1234),
        .regWrite(regWrite),
        .reset(reset),
        .readData1(readData1),
        readData2(readData2)
    );

    // testing outputs
    assign registerRead1 = readData1;
    assign registerRead2 = readData2;

endmodule