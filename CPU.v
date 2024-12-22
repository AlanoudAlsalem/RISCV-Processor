`include "PC.v"
`include "instructionMemory.v"
`include "controlUnit.v"
`include "immGen.v"
`include "registerFile.v"
`include "mux4_1.v"
`include "ALU.v"
`include "dataMemory.v"
`include "mux2_1.v"
`include "branchUnit.v"
`include "adder.v"
`include "signExtender.v"
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"

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


endmodule