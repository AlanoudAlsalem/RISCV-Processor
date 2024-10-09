// CPU connections between modules
`include "PC.v"
`include "instructionMemory.v"
// `include "registerFile.v"
`include "controlUnit.v"
// `include "mux2_1.v"
// `include "immGen.v"
// `include "CPU.v"
// `include "adder.v"
// `include "ALU.v" 

module CPU(
    input [31:0] address,
    output [31:0] out
);

    ////////////////////    IF STAGE    ////////////////////

    // connects the output of the PC to the input of the instruction memory
    wire [31:0] nextAddress;

    PC pc1(
        .nextAddress(address), 
        .readAddress(nextAddress)
    );

    // bus of the 32-bit instruction
    wire [31:0] instruction;

    instructionMemory im1(
        .instructionAddress(nextAddress), 
        .instruction(instruction)
    );

    ////////////////////    ID STAGE    ////////////////////

    //resulting control unit signals
    wire regWrite, memWrite, operation;

    controlUnit control(
        .instruction(instruction), 
        .regWrite(regWrite), 
        .memWrite(memWrite), 
        .operation(operation)
    );


endmodule