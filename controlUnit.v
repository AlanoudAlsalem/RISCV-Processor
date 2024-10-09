// The interconnection of all components to form the CPU

module controlUnit(
    input [31:0] instruction,
    output reg regWrite, // register file write signal
    output reg memWrite, // memory write signal = (memory read)'
    output reg [3:0] operation // ALU operation
);
    // extracts the opCode from the instruction
    wire [6:0] opCode = instruction[6:0];
    wire [3:0] funct3;
    wire [6:0] funct7;

    // categorizes the instruction types
    parameter
        Rtype = 6'b0110011,
        Itype1 = 6'0010011,
        Itype2 = 6'0000011;

    always @ (instruction) begin
        case(opCode)
            Rtype: funct3 = instruction[14:12], funct7 = instruction[25,31];
            Itype1: funct3 = instruction[14:12];
            Itype2: funct3 = instruction[14:12];
        endcase
    end 

    decodeOpration x1(.funct3(), .funct7(), .operation(operation));
endmodule // control unit

decodeOpration(
    input [2:0] funct3, 
    input [6:0] funct7, 
    output reg [3:0] operation
);

    parameter
        add = 4'b0000,
        sub = 4'b0001;

always @ (*)
    case({funct3, funct7})


endmodule