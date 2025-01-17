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
    input clk,
    input reset,
    output [31:0]   reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8,
                    reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16,
                    reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24,
                    reg25, reg26, reg27, reg28, reg29, reg30, reg31, reg32,
                    currentInstruction
);

    assign reg1   = r1;    assign reg2  =  r2;
    assign reg3   = r3;    assign reg4  =  r4;
    assign reg5   = r5;    assign reg6  =  r6;
    assign reg7   = r7;    assign reg8  =  r8;
    assign reg9   = r9;    assign reg10 =  r10;
    assign reg11  = r11;   assign reg12 =  r12;
    assign reg13  = r13;   assign reg14 =  r14;
    assign reg15  = r15;   assign reg16 =  r16;
    assign reg17  = r17;   assign reg18 =  r18;
    assign reg19  = r19;   assign reg20 =  r20;
    assign reg21  = r21;   assign reg22 =  r22;
    assign reg23  = r23;   assign reg24 =  r24;
    assign reg25  = r25;   assign reg26 =  r26;
    assign reg27  = r27;   assign reg28 =  r28; 
    assign reg29  = r29;   assign reg30 =  r30;
    assign reg31  = r31;   assign reg32 =  r32; 

    assign currentInstruction = readAddress;

    wire PCsrc; // mux selection
    wire [31:0] nextAddress, readAddress; // PC input and output
    wire [31:0] PCplus4, PCjump;

    mux2_1 mux1(
        .i0(PCplus4),
        .i1(PCjump),
        .select(PCsrc),
        .out(nextAddress)
    );

    PC DUT1(
        .nextAddress(nextAddress),
        .clk(clk),
        .reset(reset),
        .readAddress(readAddress)
    );

    adder adder1(
        .operand1(readAddress),
        .operand2(32'h4),
        .sum(PCplus4)
    );

    adder adder2(
        .operand1(readAddress),
        .operand2(immediate),
        .sum(PCjump)
    );

    wire [31:0] instruction; // Instruction Memory output
    
    instructionMemory DUT2(
        .instructionAddress(readAddress),
        .instruction(instruction)
    );


    //IF_ID buffer outputs
    wire [31:0] PC_out, instruction_out;

    IF_ID buffer1(
        .clk(clk),
        .reset(reset),
        .PC_in(readAddress),
        .instruction_in(instruction),
        // outputs
        .PC(PC_out),
        .instruction(instruction_out)
    );

    wire regWrite, memtoReg, memWrite, sb, lh, halt; // ALU signals
    wire [1:0] ALUsrc; // control signal
    wire [1:0] branch; // control signal
    wire [3:0] ALUop; // control signal

    controlUnit DUT3(
        .opCode(instruction_out[6:0]),
        .funct3(instruction_out[14:12]),
        .funct7(instruction_out[31:25]),
        .regWrite(regWrite),
        .memtoReg(memtoReg),
        .memWrite(memWrite),
        .branch(branch),
        .ALUsrc(ALUsrc),
        .ALUop(ALUop),
        .sb(sb),
        .lh(lh),
        .halt(halt)
    );

    wire [31:0] immediate; // immediate generated by immGen

    immGen DUT4(
        .instruction(instruction_out),
        .out(immediate)
    );

    wire [31:0] readData1, readData2; // Rs1 and Rs2
    wire [31:0] writeData; // WB mux output for reg file
    wire [31:0] r1, r2, r3, r4, r5, r6, r7, r8,
                r9, r10, r11, r12, r13, r14, r15, r16,
                r17, r18, r19, r20, r21, r22, r23, r24,
                r25, r26, r27, r28, r29, r30, r31, r32;

    registerFile DUT5(
        .readReg1(instruction_out[19:15]),
        .readReg2(instruction_out[24:20]),
        .writeReg(rd_out1),
        .writeData(writeData), 
        .regWrite(regWrite_out2),
        .reset(reset),
        .readData1(readData1),
        .readData2(readData2),
        .r1(r1), .r2(r2), .r3(r3), .r4(r4),
        .r5(r5), .r6(r6), .r7(r7), .r8(r8),
        .r9(r9), .r10(r10), .r11(r11), .r12(r12),
        .r13(r13), .r14(r14), .r15(r15), .r16(r16),
        .r17(r17), .r18(r18), .r19(r19), .r20(r20),
        .r21(r21), .r22(r22), .r23(r23), .r24(r24),
        .r25(r25), .r26(r26), .r27(r27), .r28(r28),
        .r29(r29), .r30(r30), .r31(r31), .r32(r32)
    );

    //ID_EX buffer output
    wire regWrite_out, memtoReg_out, sb_out, lh_out;
    wire [1:0] branch_out, ALUsrc_out;
    wire [3:0] ALUop_out;
    wire [31:0] PC_out1, readData1_out, readData2_out, immediate_out;
    wire [4:0] rd;

    ID_EX buffer2(
        .clk(clk),
        .reset(reset),
        .regWrite_in(regWrite),
        .memtoReg_in(memtoReg),
        .memWrite_in(memWrite),
        .sb_in(sb),
        .lh_in(lh),
        .branch_in(branch),
        .ALUsrc_in(ALUsrc),
        .ALUop_in(ALUop),
        .PC_in(PC_out),
        .readData1_in(readData1),
        .readData2_in(readData2),
        .immediate_in(immediate),
        .rd_in(instruction_out[11:7]),
        // outputs
        .regWrite(regWrite_out),
        .memtoReg(memtoReg_out),
        .memWrite(memWrite_out),
        .sb(sb_out),
        .lh(lh_out),
        .branch(branch_out),
        .ALUsrc(ALUsrc_out),
        .ALUop(ALUop_out),
        .PC(PC_out1),
        .readData1(readData1_out),
        .readData2(readData2_out),
        .immediate(immediate_out),
        .rd(rd)
    );

    wire [31:0] operand2; // mux selection

    mux4_1 mux2(
        .i0(readData2_out),
        .i1(immediate_out),
        .i2(PC_out1),
        .select(ALUsrc_out),
        .out(operand2)
    );

    wire [31:0] ALUresult; // ALU result
    wire zeroFlag;

    ALU DUT6(
        .operation(ALUop_out),
        .operand1(readData1_out),
        .operand2(operand2),
        .result(ALUresult),
        .zeroFlag(zeroFlag)
    );

    wire regWrite_out1, memtoReg_out1, memWrite_out1, sb_out1, lh_out1, zeroFlag_out;
    wire [1:0] branch_out1;
    wire [31:0] readData2_out1, ALUresult_out;
    wire [4:0] rd_out;

    EX_MEM buffer3(
        .clk(clk),
        .reset(reset),
        .regWrite_in(regWrite_out),
        .memtoReg_in(memtoReg_out),
        .memWrite_in(memWrite_out),
        .sb_in(sb_out),
        .lh_in(lh_out),
        .zeroFlag_in(zeroFlag),
        .branch_in(branch_out),
        .readData2_in(readData2_out),
        .ALUresult_in(ALUresult),
        .rd_in(rd),
        // outputs
        .regWrite(regWrite_out1),
        .memtoReg(memtoReg_out1),
        .memWrite(memWrite_out1),
        .sb(sb_out1),
        .lh(lh_out1),
        .zeroFlag(zeroFlag_out),
        .branch(branch_out1),
        .readData2(readData2_out1),
        .ALUresult(ALUresult_out),
        .rd(rd_out)
    );

    wire [31:0] data, outputData; // data memory output

    dataMemory DUT7(
        .dataAddress(ALUresult_out),
        .writeData(readData2_out1),
        .memWrite(memWrite_out1),
        .sb(sb_out1),
        .data(data)
    );

    branchUnit DUT8(
        .branch(branch_out1),
        .zeroFlag(zeroFlag_out1),
        .PCsrc(PCsrc)
    );

    wire regWrite_out2, memtoReg_out2, lh_out2;
    wire [31:0] ALUresult_out1, data_out;
    wire [4:0] rd_out1;

    MEM_WB buffer4(
        .clk(clk),
        .reset(reset),
        .regWrite_in(regWrite_out1),
        .memtoReg_in(memtoReg_out1),
        .lh_in(lh_out1),
        .ALUresult_in(ALUresult_out),
        .data_in(data),
        .rd_in(rd_out),
        // outputs
        .regWrite(regWrite_out2),
        .memtoReg(memtoReg_out2),
        .lh(lh_out2),
        .ALUresult(ALUresult_out1),
        .data(data_out),
        .rd(rd_out1)
    );

    signExtender DUT9(
        .lh(lh_out2),
        .inputData(data_out),
        .outputData(outputData)
    );

    mux2_1 mux3(
        .i0(outputData),
        .i1(ALUresult_out1),
        .select(memtoReg_out2),
        .out(writeData)
    );

endmodule