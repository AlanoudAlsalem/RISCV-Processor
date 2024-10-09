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
    wire [31:0] instruction;

    CPU cpu1(
        .address(address), 
        .instruction(instruction));

    initial begin 
        address = 0; 
        #1 $display ("Address = %d | Instruction = %h", address, instruction);
        address = 4; 
        #1 $display ("Address = %d | Instruction = %h", address, instruction);
    end

endmodule