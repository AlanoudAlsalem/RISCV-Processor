`include "PC.v"
`include "instructionMemory.v"
`include "controlUnit.v"
`include "immGen.v"
`include "registerFile.v"
`include "mux4_1.v"
`include "ALU.v"
`include "dataMemory.v"
`include "mux2_1.v"
`include "branchUnitPred.v"
`include "adder.v"
`include "signExtender.v"
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"
`include "forwardingUnit.v"


module CPUwithoutCache(
    input clock, reset,
    output halt,
    output [31:0] r1, r2, r3, r4, r5, r6, r7, r8,
                r9, r10, r11, r12, r13, r14, r15, r16,
                r17, r18, r19, r20, r21, r22, r23, r24,
                r25, r26, r27, r28, r29, r30, r31, r32
);

    // IF STAGE ##################################################################
    wire [31:0] readAddress; // PC output
    wire [31:0] pcPlus4, pcBranched, selectedPC; // next PC addresses
    wire [31:0] pcBranchOperand; // immediate or RS added to PC (for jal)
    wire [31:0] instruction; // instruction memory output
    // buffer
    wire [31:0] instruction_IF_ID_out, PC_IF_ID_out;
    // ID STAGE ##################################################################
    wire regWrite, memtoReg, memWrite, sb, lh, ld, jalr; // control signals
    wire [1:0] ALUsrc;
    wire [3:0] ALUop;
    // register file
    wire [31:0] readData1, readData2; // Rs1 and Rs2 contents
    // immGen
    wire [31:0] immediate;
    // branch Unit Muxes
    wire [31:0] branchUnitOperand1, branchUnitOperand2;
    //branch Unit
    wire PCsrc;
    // forwarding unit 
    wire [1:0] forwardOp1, forwardOp2, ID_forwardOp1, ID_forwardOp2;
    wire nop;
    // EX STAGE ##################################################################
    // buffer
    wire    regWrite_ID_EX_out, memtoReg_ID_EX_out, memWrite_ID_EX_out, sb_ID_EX_out, lh_ID_EX_out,
            ld_ID_EX_out, halt_ID_EX_out;
    wire [1:0] ALUsrc_ID_EX_out;
    wire [3:0] ALUop_ID_EX_out;
    wire [31:0] PC_ID_EX_out, readData1_ID_EX_out, readData2_ID_EX_out, immediate_ID_EX_out;
    wire [4:0] rd_ID_EX_out, rs1_ID_EX_out, rs2_ID_EX_out;
    // MUX outputs
    wire [31:0] forwardedOp1, forwardedOp2, selectedOp2;
    // ALU results
    wire [31:0] ALUresult;
    wire zeroFlag;
    // MEM STAGE ##################################################################
    // buffer
    wire regWrite_EX_MEM_out, memtoReg_EX_MEM_out, memWrite_EX_MEM_out, sb_EX_MEM_out, lh_EX_MEM_out, halt_EX_MEM_out;
    wire [31:0] readData2_EX_MEM_out, ALUresult_EX_MEM_out;
    wire [4:0] rd_EX_MEM_out;
    // data memory outputs
    wire [31:0] data, m0, m4, m8, m12, m16, m20, m24, m28, m32, m36;
    // WB STAGE ##################################################################
    // buffer
    wire regWrite_MEM_WB_out, memtoReg_MEM_WB_out, lh_MEM_WB_out, halt_MEM_WB_out;
    wire [31:0] ALUresult_MEM_WB_out, data_MEM_WB_out;
    wire [4:0] rd_MEM_WB_out;
    // sign extender
    wire [31:0] signExtenderOutputData;
    // WB mux selection
    wire [31:0] writeBackData;


mux2_1 pcMux(
    .i0(pcPlus4),
    .i1(pcBranched),
    .select(PCsrc),
    .out(selectedPC)
);

PC programCounter(
    .clock(clock),
    .reset(reset),
    .nop(nop),
    .nextAddress(selectedPC),
    //output
    .readAddress(readAddress)
);

adder add4Adder(
    .operand1(readAddress),
    .operand2(32'd4),
    .sum(pcPlus4)
);

mux2_1 pcBranchAdderMux(
    .i0(immediate), // immediate value
    .i1(readData1), // register value (change for forwarding)
    .select(jalr),
    .out(pcBranchOperand)
);

adder branchAdder(
    .operand1(readAddress),
    .operand2(pcBranchOperand),
    .sum(selectedPC)
);

instructionMemory instMem(
    .instructionAddress(readAddress),
    .instruction(instruction)
);

// ################################################# ID #################################################

IF_ID bufferIF_ID(
    .clock(clock),
    .reset(reset),
    .flush(PCsrc),
    .PC_in(readAddress),
    .instruction_in(instruction),
    .PC(PC_IF_ID_out),
    .instruction(instruction_IF_ID_out)
);

controlUnit controlUnit(
    .opCode(instruction_IF_ID_out[6:0]),
    .funct3(instruction_IF_ID_out[14:12]),
    .funct7(instruction_IF_ID_out[31:25]),
    .nop(),
    // outputs
    .regWrite(regWrite),
    .memtoReg(memtoReg),
    .memWrite(memWrite),
    .ALUsrc(ALUsrc),
    .ALUop(ALUop),
    .sb(sb),
    .lh(lh),
    .ld(ld),
    .jalr(jalr),
    .halt(halt)
);

registerFile registerFile(
    .clock(clock),
    .reset(reset),
    .readReg1(instruction_IF_ID_out[19:15]),
    .readReg2(instruction_IF_ID_out[24:20]),
    .writeReg(rd_MEM_WB_out),
    .writeData(writeBackData),
    .regWrite(regWrite_MEM_WB_out),
    // outputs
    .readData1(readData1),
    .readData2(readData2),
    .r1(r1),    .r2(r2),    .r3(r3),    .r4(r4),
    .r5(r5),    .r6(r6),    .r7(r7),    .r8(r8),
    .r9(r9),    .r10(r10),  .r11(r11),  .r12(r12),
    .r13(r13),  .r14(r14),  .r15(r15),  .r16(r16),
    .r17(r17),  .r18(r18),  .r19(r19),  .r20(r20),
    .r21(r21),  .r22(r22),  .r23(r23),  .r24(r24),
    .r25(r25),  .r26(r26),  .r27(r27),  .r28(r28),
    .r29(r29),  .r30(r30),  .r31(r31),  .r32(r32)
);

immGen immediateGen(
    .instruction(instruction_IF_ID_out),
    .out(immediate)
);

mux4_1 branchUnitOp1Mux(
    .i0(readData1),
    .i1(ALUresult_EX_MEM_out),
    .i2(writeBackData),
    .select(ID_forwardOp1),
    .out(branchUnitOperand1)
);

mux4_1 branchUnitOp2Mux(
    .i0(readData2),
    .i1(ALUresult_EX_MEM_out),
    .i2(writeBackData),
    .select(ID_forwardOp2),
    .out(branchUnitOperand2)
);

branchUnitPred branchUnit(
    .clock(clock),
    .opCode(instruction_IF_ID_out[6:0]),
    .funct3(instruction_IF_ID_out[14:12]),
    .operand1(branchUnitOperand1),
    .operand2(branchUnitOperand2),
    // output
    .PCsrc(PCsrc)
);

forwardingUnit fwUnit(
    .clock(clock),
    .reset(reset),
    .opCode(instruction_IF_ID_out[6:0]),
    .ID_EX_rd(rd_ID_EX_out),
    .EX_MEM_rd(rd_EX_MEM_out), 
    .MEM_WB_rd(rd_MEM_WB_out), 
    .IF_ID_rs1(instruction_IF_ID_out[19:15]), 
    .IF_ID_rs2(instruction_IF_ID_out[24:20]), 
    .ID_EX_rs1(rs1_ID_EX_out), 
    .ID_EX_rs2(rs2_ID_EX_out),
    .regWrite_EX_MEM(regWrite_EX_MEM_out), 
    .regWrite_MEM_WB(regWrite_MEM_WB_out), 
    .load_ID_EX(ld_ID_EX_out), 
    .branch(),
    // outputs
    .forwardOp1(forwardOp1), 
    .forwardOp2(forwardOp2),
    .ID_forwardOp1(ID_forwardOp1), 
    .ID_forwardOp2(ID_forwardOp2),
    .nop(nop)
);

// ################################################# EX #################################################
ID_EX bufferID_EX(
    .clock(clock),
    .reset(reset),
    .nop(nop),
    .regWrite_in(regWrite),
    .memtoReg_in(memtoReg),
    .memWrite_in(memWrite),
    .sb_in(sb),
    .lh_in(lh),
    .ld_in(ld),
    .ALUsrc_in(ALUsrc),
    .ALUop_in(ALUop),
    .PC_in(PC_IF_ID_out),
    .readData1_in(readData1),
    .readData2_in(readData2),
    .immediate_in(immediate),
    .rd_in(instruction_IF_ID_out[11:7]),
    .rs1_in(instruction_IF_ID_out[19:15]),
    .rs2_in(instruction_IF_ID_out[24:20]),
    .halt_in(halt),
    // outputs
    .regWrite(regWrite_ID_EX_out),
    .memtoReg(memtoReg_ID_EX_out),
    .memWrite(memWrite_ID_EX_out),
    .sb(sb_ID_EX_out),
    .lh(lh_ID_EX_out),
    .ld(ld_ID_EX_out),
    .halt(halt_ID_EX_out),
    .ALUsrc(ALUsrc_ID_EX_out),
    .ALUop(ALUop_ID_EX_out),
    .PC(PC_ID_EX_out),
    .readData1(readData1_ID_EX_out),
    .readData2(readData2_ID_EX_out),
    .immediate(immediate_ID_EX_out),
    .rd(rd_ID_EX_out),
    .rs1(rs1_ID_EX_out),
    .rs2(rs2_ID_EX_out)
);

mux4_1 forwardALUOp1(
    .i0(readData1_ID_EX_out),
    .i1(ALUresult_EX_MEM_out),
    .i2(writeBackData),
    .select(forwardOp1),
    .out(forwardedOp1)
);

mux4_1 forwardALUOp2(
    .i0(readData2_ID_EX_out),
    .i1(ALUresult_EX_MEM_out),
    .i2(writeBackData),
    .select(forwardOp2),
    .out(forwardedOp2)
);

mux4_1 selectALUOp2(
    .i0(forwardedOp2),
    .i1(immediate_ID_EX_out),
    .i2(PC_ID_EX_out),
    .select(ALUsrc_ID_EX_out),
    .out(selectedOp2)
);

ALU ALUDUT(
    .operation(ALUop_ID_EX_out),
    .operand1(forwardedOp1),
    .operand2(selectedOp2),
    // outputs
    .result(ALUresult),
    .zeroFlag(zeroFlag)
);

// ################################################# MEM #################################################
EX_MEM bufferEX_MEM(
    .clock(clock),
    .reset(reset),
    .regWrite_in(regWrite_ID_EX_out), 
    .memtoReg_in(memtoReg_ID_EX_out), 
    .memWrite_in(memWrite_ID_EX_out), 
    .sb_in(sb_ID_EX_out), 
    .lh_in(lh_ID_EX_out),
    .readData2_in(forwardedOp2),
    .ALUresult_in(ALUresult),
    .rd_in(rd_ID_EX_out),
    .halt_in(halt_ID_EX_out),
    // outputs
    .regWrite(regWrite_EX_MEM_out), 
    .memtoReg(memtoReg_EX_MEM_out), 
    .memWrite(memWrite_EX_MEM_out), 
    .sb(sb_EX_MEM_out), 
    .lh(lh_EX_MEM_out),
    .readData2(readData2_EX_MEM_out),
    .ALUresult(ALUresult_EX_MEM_out),
    .rd(rd_EX_MEM_out),
    .halt(halt_EX_MEM_out)
);

dataMemory dataMem(
    .dataAddress(ALUresult_EX_MEM_out),
    .writeData(readData2_EX_MEM_out),
    .memWrite(memWrite_EX_MEM_out),
    .sb(sb_EX_MEM_out),
    // outputs
    .data(data),
    .m0(m0),    .m4(m4),    .m8(m8),    .m12(m12),  .m16(m16),     
    .m20(m20),  .m24(m24),  .m28(m28),  .m32(m32),  .m36(m36)
);

// ################################################# WB #################################################
MEM_WB bufferMEM_WB(
    .clock(clock),
    .reset(reset),
    .regWrite_in(regWrite_EX_MEM_out),
    .memtoReg_in(memtoReg_EX_MEM_out),
    .lh_in(lh_EX_MEM_out),
    .ALUresult_in(),
    .data_in(data),
    .rd_in(rd_EX_MEM_out),
    .halt_in(halt_EX_MEM_out),
    // outputs
    .regWrite(regWrite_MEM_WB_out),
    .memtoReg(memtoReg_MEM_WB_out),
    .lh(lh_MEM_WB_out),
    .ALUresult(ALUresult_MEM_WB_out),
    .data(data_MEM_WB_out),
    .rd(rd_MEM_WB_out),
    .halt(halt_MEM_WB_out)
);

signExtender signExtenderDUT(
    .lh(lh_MEM_WB_out),
    .inputData(data_MEM_WB_out),
    // output
    .outputData(signExtenderOutputData)
);

mux2_1 memtoRegMux(
    .i0(signExtenderOutputData),
    .i1(ALUresult_MEM_WB_out),
    .select(memtoReg_MEM_WB_out),
    .out(writeBackData)
);

endmodule
