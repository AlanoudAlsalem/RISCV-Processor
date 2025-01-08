module forwardingUnit
# (parameter 
    bOp     = 7'h63,
    jalrOp  = 7'h67
)

(   input clock,
    input reset,
    input [6:0] opCode,
    input [4:0] ID_EX_rd, EX_MEM_rd, MEM_WB_rd, 
    input [4:0] IF_ID_rs1, IF_ID_rs2, ID_EX_rs1, ID_EX_rs2,
    input regWrite_ID_EX, regWrite_EX_MEM, regWrite_MEM_WB, load_ID_EX, load_EX_MEM,
    input [1:0] branch,
    output reg [1:0] forwardOp1, forwardOp2, // 00 = default value, 01 = EX_MEM rd, 10 = MEM_WB rd
    output reg [1:0] ID_forwardOp1, ID_forwardOp2,
    output reg nop
);

    always @ (*) begin
        forwardOp1      <= 2'b0;
        forwardOp2      <= 2'b0;
        ID_forwardOp1   <= 2'b0;
        ID_forwardOp2   <= 2'b0;

        if(reset)
            nop         <= 1'b0;
        else begin
            // load use: if load in execute stage and destination register matches source of current (non-branch) instruction in decode stage
            // once the load becomes in the write-back stage, the current instruction will be in the execute stage (forwarding properly)
            if(load_ID_EX && ID_EX_rd != 0 && (ID_EX_rd == IF_ID_rs1 | ID_EX_rd == IF_ID_rs2))
                nop <= 1;
            else if(opCode == bOp || opCode == jalrOp) begin // note that a nop + branch in decode stage makes the branch decision invalid
                // load-use
                // if (beq, bne, jalr, jal) instruction in decode stage, and an load instruction is in the mem stage 
                // once the load becomes in the write-back stage, the current instruction will be in the execute stage (forwarding properly)
                if(load_EX_MEM && EX_MEM_rd != 0 && (EX_MEM_rd == IF_ID_rs1 | EX_MEM_rd == IF_ID_rs2))
                    nop <= 1;
                // R-type
                // if (beq, bne, jalr, jal) instruction in decode stage, and an R-type instruction is in the execute stage
                // once the R-type becomes in the mem stage, the branch will be in the decode (forwarding after result is produced)
                else if(ID_EX_rd != 0 && regWrite_ID_EX && (ID_EX_rd == IF_ID_rs1 | ID_EX_rd == IF_ID_rs2))
                    nop <= 1;
            end
            else
                nop         <= 1'b0;
        
            // data hazard
            if      (EX_MEM_rd !=0 && regWrite_EX_MEM && (EX_MEM_rd == ID_EX_rs1))
                forwardOp1  <= 2'b01;
            else if (MEM_WB_rd !=0 && regWrite_MEM_WB && (MEM_WB_rd == ID_EX_rs1))
                forwardOp1 <= 2'b10;
            
            if      (EX_MEM_rd !=0 && regWrite_EX_MEM && (EX_MEM_rd == ID_EX_rs2))
                forwardOp2  <= 2'b01;
            else if (MEM_WB_rd !=0 && regWrite_MEM_WB && (MEM_WB_rd == ID_EX_rs2))
                forwardOp2 <= 2'b10;

            // branch and jalr instructions forwarding
            if (opCode == bOp || opCode == jalrOp) begin
                if      (EX_MEM_rd !=0 && regWrite_EX_MEM && (EX_MEM_rd == IF_ID_rs1))
                    ID_forwardOp1  <= 2'b01;
                else if (MEM_WB_rd !=0 && regWrite_MEM_WB && (MEM_WB_rd == IF_ID_rs1))
                    ID_forwardOp1 <= 2'b10;
                
                if      (EX_MEM_rd !=0 && regWrite_EX_MEM && (EX_MEM_rd == IF_ID_rs2))
                    ID_forwardOp2  <= 2'b01;
                else if (MEM_WB_rd !=0 && regWrite_MEM_WB && (MEM_WB_rd == IF_ID_rs2))
                    ID_forwardOp2 <= 2'b10;
            end
        end
    end

    always @ (negedge clock)
        nop <= 0;
    
endmodule