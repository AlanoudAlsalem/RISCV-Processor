`include "PC.v"
`include "instructionMemory.v"
`include "controlUnit.v"
`include "immGen.v"
`include "registerFile.v"
`include "mux4_1.v"
`include "ALU.v"
`include "mux2_1.v"
`include "branchUnitPred.v"
`include "adder.v"
`include "signExtender.v"
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"
`include "forwardingUnit.v"
`include "DataCache.v"
`include "instructionCache.v"

module cacheMicroTestbench;
    reg clock;
    reg reset; // reset signal

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
    wire [31:0] r1, r2, r3, r4, r5, r6, r7, r8,
                r9, r10, r11, r12, r13, r14, r15, r16,
                r17, r18, r19, r20, r21, r22, r23, r24,
                r25, r26, r27, r28, r29, r30, r31, r32;
    // immGen
    wire [31:0] immediate;
    // branch Unit Muxes
    wire [31:0] branchUnitOperand1, branchUnitOperand2;
    //branch Unit
    wire PCsrc;
    wire predicted;
    wire [1:0] state;
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
    wire regWrite_EX_MEM_out, memtoReg_EX_MEM_out, memWrite_EX_MEM_out, sb_EX_MEM_out, lh_EX_MEM_out, ld_EX_MEM_out, halt_EX_MEM_out;
    wire [31:0] readData2_EX_MEM_out, ALUresult_EX_MEM_out;
    wire [4:0] rd_EX_MEM_out;
    // data memory outputs
    wire [31:0] data, m0, m4, m8, m12, m16, m20, m24, m28, m32, m36;
    wire [31:0] c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10,
                c11, c12, c13, c14, c15;
    // WB STAGE ##################################################################
    // buffer
    wire regWrite_MEM_WB_out, memtoReg_MEM_WB_out, lh_MEM_WB_out, halt_MEM_WB_out;
    wire [31:0] ALUresult_MEM_WB_out, data_MEM_WB_out;
    wire [4:0] rd_MEM_WB_out;
    // sign extender
    wire [31:0] signExtenderOutputData;
    // WB mux selection
    wire [31:0] writeBackData;

// ################################################# IF #################################################

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
    .branch(PCsrc),
    .immediate(immediate),
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
    .i1(branchUnitOperand1), // register value (change for forwarding)
    .select(jalr),
    .out(pcBranchOperand)
);
 adder branchAdder(
     .operand1(readAddress - 4),
     .operand2(pcBranchOperand),
     .sum(pcBranched)
 );

InstructionCache instMem(
    .reset(reset),
    .clock(clock),
    .instructionAddress(readAddress),
    .instruction(instruction)
);

// ################################################# ID #################################################

IF_ID bufferIF_ID(
    .clock(clock),
    .reset(reset),
    .jalr(jalr),
    .PC_in(readAddress),
    .instruction_in(instruction),
    .PC(PC_IF_ID_out),
    .instruction(instruction_IF_ID_out)
);

controlUnit controlUnit(
    .opCode(instruction_IF_ID_out[6:0]),
    .funct3(instruction_IF_ID_out[14:12]),
    .funct7(instruction_IF_ID_out[31:25]),
    .nop(nop),
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
    .reset(reset),
    .nop(nop),
    .opCode(instruction_IF_ID_out[6:0]),
    .funct3(instruction_IF_ID_out[14:12]),
    .operand1(branchUnitOperand1),
    .operand2(branchUnitOperand2),
    // outputs
    .PCsrc(PCsrc),
    .predicted(predicted),
    .state(state)
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
    .regWrite_ID_EX(regWrite_ID_EX_out), 
    .regWrite_EX_MEM(regWrite_EX_MEM_out), 
    .regWrite_MEM_WB(regWrite_MEM_WB_out), 
    .load_ID_EX(ld_ID_EX_out), 
    .load_EX_MEM(),
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
    .ld_in(ld_ID_EX_out),
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
    .ld(ld_EX_MEM_out),
    .readData2(readData2_EX_MEM_out),
    .ALUresult(ALUresult_EX_MEM_out),
    .rd(rd_EX_MEM_out),
    .halt(halt_EX_MEM_out)
);


DataCache dataCache(
    .reset(reset),
    .clock(clock),
    .sb(sb_EX_MEM_out),
    .address(ALUresult_EX_MEM_out),
    .writeData(readData2_EX_MEM_out),
    .writeEnable(memWrite_EX_MEM_out),
    .data(data),
    .m0(m0),    .m4(m4),    .m8(m8),    .m12(m12),  .m16(m16),     
    .m20(m20),  .m24(m24),  .m28(m28),  .m32(m32),  .m36(m36),
    .c0(c0) ,.c1(c1) ,.c2(c2) ,.c3(c3) ,.c4(c4) ,.c5(c5) ,.c6(c6) ,.c7(c7) ,.c8(c8),
    .c9(c9) ,.c10(c10), .c11(c11), .c12(c12), .c13(c13), .c14(c14), .c15(c15)
);

// ################################################# WB #################################################
MEM_WB bufferMEM_WB(
    .clock(clock),
    .reset(reset),
    .regWrite_in(regWrite_EX_MEM_out),
    .memtoReg_in(memtoReg_EX_MEM_out),
    .lh_in(lh_EX_MEM_out),
    .ALUresult_in(ALUresult_EX_MEM_out),
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

    // ####################################################### TESTING #######################################################

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, cacheMicroTestbench);
    end
    integer cycles = 0;

    initial begin
        cycles = cycles + 1;
        clock = 0; reset = 0; #1 reset = 1; #4 
        $display("\n---------------------------------------------------------------------------");
        $display("Cycle #%d", cycles);
        $display("\n---------------------------------------------------------------------------");
        $display("############################### IF ###############################");
        $display("PCplus4 = %d pcBranched = %d, PCsrc = %b, selected PC = %d", pcPlus4, pcBranched, PCsrc, selectedPC);
        $display("PC output: readAddress = %d", readAddress);
        $display("jalr = %b, pcBranchOperand = %d", jalr, $signed(pcBranchOperand));
        $display("Instruction Memory: Instruction Address= %d Instruction = %h", readAddress, instruction);
        $display("############################### ID ###############################");
        $display("CU: opCode = %h, funct3 = %h, funct7 = %h", instruction_IF_ID_out[6:0], instruction_IF_ID_out[14:12], instruction_IF_ID_out[31:25]); 
        $display("nop = %b, regWrite = %b, memtoReg = %b, memWrite = %b, sb = %b, lh = %b, ld = %b, ALUsrc = %b, ALUop = %b, jalr = %b Halt = %b", 
                nop, regWrite, memtoReg, memWrite, sb, lh, ld, ALUsrc, ALUop, jalr, halt);
        $display("immediate = %d", $signed(immediate));
        $display("Rs1 = %d Rs2 = %d", instruction_IF_ID_out[19:15], instruction_IF_ID_out[24:20]);
        $display("Register file content:");
        $display("x0: %d \tx1: %d",   $signed(r1), $signed(r2));
        $display("x2: %d \tx3: %d",   $signed(r3), $signed(r4));
        $display("x4: %d \tx5: %d",   $signed(r5), $signed(r6));
        $display("x6: %d \tx7: %d",   $signed(r7), $signed(r8));
        $display("x8: %d \tx9: %d",   $signed(r9), $signed(r10));
        $display("x10: %d\tx11: %d", $signed(r11), $signed(r12));
        $display("x12: %d\tx13: %d", $signed(r13), $signed(r14));
        $display("x14: %d\tx15: %d", $signed(r15), $signed(r16));
        $display("x16: %d\tx17: %d", $signed(r17), $signed(r18));
        $display("x18: %d\tx19: %d", $signed(r19), $signed(r20));
        $display("x20: %d\tx21: %d", $signed(r21), $signed(r22));
        $display("x22: %d\tx23: %d", $signed(r23), $signed(r24));
        $display("x24: %d\tx25: %d", $signed(r25), $signed(r26));
        $display("x26: %d\tx27: %d", $signed(r27), $signed(r28));
        $display("x28: %d\tx29: %d", $signed(r29), $signed(r30));
        $display("x30: %d\tx31: %d", $signed(r31), $signed(r32));
        $display("ReadData1 = %d ReadData2 = %d", readData1, readData2);
        $display("ID_EX_rd = %d EX_MEM_rd = %d MEM_WB_rd = %d", rd_ID_EX_out, rd_EX_MEM_out, rd_MEM_WB_out);
        $display("IF_ID_rs1 = %d IF_ID_rs2 = %d", instruction_IF_ID_out[19:15], instruction_IF_ID_out[24:20]);
        $display("ID_EX_rs1 = %d ID_EX_rs2 = %d", rs1_ID_EX_out, rs2_ID_EX_out);
        $display("regWrite EX_MEM = %b regWrite MEM_WB = %b", regWrite_EX_MEM_out, regWrite_MEM_WB_out);
        $display("load_ID_EX = %b", ld_ID_EX_out);
        $display("Forwarding: forwardOp1 = %b forwardOp2 = %b ID_forwardOp1 = %b ID_forwardOp2 = %b nop = %b, opCode = %h", 
            forwardOp1, forwardOp2, ID_forwardOp1, ID_forwardOp2, nop, instruction_IF_ID_out[6:0]);
        $display("Branch unit op1 = %d op2 = %d, PCsrc = %b", branchUnitOperand1, branchUnitOperand2, PCsrc);
        $display("############################### EX ###############################");
        $display("ALU: operand 1 = %d operand 2 = %d operation = %h", forwardedOp1, selectedOp2, ALUop_ID_EX_out);
        $display("Result = %d zeroFlag = %d", ALUresult, zeroFlag);
        $display("############################### MEM ###############################");
        $display("Data address = %d, write Data = %d, output Data = %d", ALUresult_EX_MEM_out, readData2_EX_MEM_out, data);
        $display("Data memory contet:");
        $display("m0: %d\tm4: %d", m0, m4);
        $display("m8: %d\tm16: %d", m8, m16);
        $display("m20: %d\tm24: %d", m20, m24);
        $display("m28: %d\tm32: %d", m28, m32);
        $display("m36: %d", m36);
        $display("############################### WB ###############################");
        $display("Sign Extender Output = %d ALUresult = %d, select = %b", signExtenderOutputData, ALUresult_MEM_WB_out, memtoReg_MEM_WB_out);
        $display("Write back data = %d", writeBackData);

        reset = 0;
        
        forever #5 clock = ~clock;
    end

    

    always @ (posedge clock) begin
        if(halt_MEM_WB_out)
            $finish;
        
        cycles = cycles + 1;
        #1
        $display("\n----------------------------------posedge-----------------------------------------");
        $display("Cycle #%d", cycles);
        $display("\n---------------------------------------------------------------------------");
        $display("############################### IF ###############################");
        $display("PCplus4 = %d pcBranched = %d, PCsrc = %b, selected PC = %d", pcPlus4, pcBranched, PCsrc, selectedPC);
        $display("PC output: readAddress = %d", readAddress);
        $display("jalr = %b, pcBranchOperand = %d", jalr, $signed(pcBranchOperand));
        $display("Instruction Memory: Instruction Address= %d Instruction = %h", readAddress, instruction);
        $display("############################### ID ###############################");
        $display("CU: opCode = %h, funct3 = %h, funct7 = %h", instruction_IF_ID_out[6:0], instruction_IF_ID_out[14:12], instruction_IF_ID_out[31:25]); 
        $display("nop = %b, regWrite = %b, memtoReg = %b, memWrite = %b, sb = %b, lh = %b, ld = %b, ALUsrc = %b, ALUop = %b, jalr = %b Halt = %b", 
                nop, regWrite, memtoReg, memWrite, sb, lh, ld, ALUsrc, ALUop, jalr, halt);
        $display("immediate = %d", $signed(immediate));
        $display("Rs1 = %d Rs2 = %d", instruction_IF_ID_out[19:15], instruction_IF_ID_out[24:20]);
        $display("Register file content:");
        $display("x0: %d \tx1: %d",   $signed(r1), $signed(r2));
        $display("x2: %d \tx3: %d",   $signed(r3), $signed(r4));
        $display("x4: %d \tx5: %d",   $signed(r5), $signed(r6));
        $display("x6: %d \tx7: %d",   $signed(r7), $signed(r8));
        $display("x8: %d \tx9: %d",   $signed(r9), $signed(r10));
        $display("x10: %d\tx11: %d", $signed(r11), $signed(r12));
        $display("x12: %d\tx13: %d", $signed(r13), $signed(r14));
        $display("x14: %d\tx15: %d", $signed(r15), $signed(r16));
        $display("x16: %d\tx17: %d", $signed(r17), $signed(r18));
        $display("x18: %d\tx19: %d", $signed(r19), $signed(r20));
        $display("x20: %d\tx21: %d", $signed(r21), $signed(r22));
        $display("x22: %d\tx23: %d", $signed(r23), $signed(r24));
        $display("x24: %d\tx25: %d", $signed(r25), $signed(r26));
        $display("x26: %d\tx27: %d", $signed(r27), $signed(r28));
        $display("x28: %d\tx29: %d", $signed(r29), $signed(r30));
        $display("x30: %d\tx31: %d", $signed(r31), $signed(r32));
        $display("ReadData1 = %d ReadData2 = %d", readData1, readData2);
        $display("ID_EX_rd = %d EX_MEM_rd = %d MEM_WB_rd = %d", rd_ID_EX_out, rd_EX_MEM_out, rd_MEM_WB_out);
        $display("IF_ID_rs1 = %d IF_ID_rs2 = %d", instruction_IF_ID_out[19:15], instruction_IF_ID_out[24:20]);
        $display("ID_EX_rs1 = %d ID_EX_rs2 = %d", rs1_ID_EX_out, rs2_ID_EX_out);
        $display("regWrite EX_MEM = %b regWrite MEM_WB = %b", regWrite_EX_MEM_out, regWrite_MEM_WB_out);
        $display("load_ID_EX = %b", ld_ID_EX_out);
        $display("Forwarding: forwardOp1 = %b forwardOp2 = %b ID_forwardOp1 = %b ID_forwardOp2 = %b nop = %b, opCode = %h", 
            forwardOp1, forwardOp2, ID_forwardOp1, ID_forwardOp2, nop, instruction_IF_ID_out[6:0]);
        $display("Branch unit op1 = %d op2 = %d, PCsrc = %b, predicted = %b, state = %b", branchUnitOperand1, branchUnitOperand2, PCsrc, predicted, state);
        $display("############################### EX ###############################");
        $display("ALU: operand 1 = %d operand 2 = %d operation = %h", forwardedOp1, selectedOp2, ALUop_ID_EX_out);
        $display("Result = %d zeroFlag = %d", ALUresult, zeroFlag);
        $display("############################### MEM ###############################");
        $display("Data address = %d, write Data = %d, output Data = %d", ALUresult_EX_MEM_out, readData2_EX_MEM_out, data);
        $display("Cache content: ");
        $display("%d %d \n %d %d \n %d %d \n %d %d \n %d %d \n %d %d \n %d %d \n %d %d \n", c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10,
                c11, c12, c13, c14, c15);
        $display("Data memory contet:");
        $display("m0: %d\tm4: %d", m0, m4);
        $display("m8: %d\tm12: %d", m8, m12);
        $display("m16: %d\tm20: %d", m16, m20);
        $display("m24: %d\tm28: %d", m24, m28);
        $display("m32: %d\tm36: %d", m32, m36);
        $display("############################### WB ###############################");
        $display("Sign Extender Output = %d ALUresult = %d, select = %b", signExtenderOutputData, ALUresult_MEM_WB_out, memtoReg_MEM_WB_out);
        $display("Write back data = %d", writeBackData);
    end

endmodule
