/* `include "PC.v"
`include "instructionMemory.v"
`include "registerFile.v"
`include "controlUnit.v"
`include "mux2_1.v"
`include "immGen.v" */
`include "CPU.v"
//`include "adder.v"
// `include "ALU.v"

module testbench;
    reg [31:0] address;
    wire [31:0] pcOut;
    wire [31:0] instructionMemoryOut;
    wire [31:0] registerRead1;
    wire [31:0] registerRead2;
    wire regWriteSignal;
    wire memWriteSignal;
    wire [2:0] aluOPout;
    wire [31:0] out;

    CPU DUT(
        .address(address),
        .pcOut(pcOut),
        .instructionMemoryOut(instructionMemoryOut),
        .registerRead1(registerRead1),
        .registerRead2(registerRead2),
        .regWriteSignal(regWriteSignal),
        .memWriteSignal(memWriteSignal),
        .aluOPout(aluOPout),
        .out(out)
    );

    initial begin 
        address = 0; 
        #1 $display ("Address = %d | Instruction = %h", address, instruction);
        address = 4; 
        #1 $display ("Address = %d | Instruction = %h", address, instruction);
        address = 8; 
        #1 $display ("Address = %d | Instruction = %h", address, instruction);
        address = 12; 
        #1 $display ("Address = %d | Instruction = %h", address, instruction);
    end

endmodule