module forwardingUnit(
    input clock,
    input reset,
    input [4:0] ID_EX_rd, EX_MEM_rd, MEM_WB_rd, 
    input [4:0] IF_ID_rs1, IF_ID_rs2, ID_EX_rs1, ID_EX_rs2,
    input regWrite_EX_MEM, regWrite_MEM_WB, load_ID_EX, 
    output reg [1:0] forwardOp1, // 00 = default value, 01 = EX_MEM rd, 10 = MEM_WB rd
                     forwardOp2, // 00 = default value, 01 = EX_MEM rd, 10 = MEM_WB rd
    output nop
);

    assign nop = load_ID_EX && (ID_EX_rd == IF_ID_rs1 | ID_EX_rd == IF_ID_rs2);

    always @ (*) begin
        forwardOp1  <= 2'b0;
        forwardOp2  <= 2'b0;
        // data hazard
        if      (EX_MEM_rd !=0 && regWrite_EX_MEM && (EX_MEM_rd == ID_EX_rs1))
            forwardOp1  <= 2'b01;
        else if (MEM_WB_rd !=0 && regWrite_MEM_WB && (MEM_WB_rd == ID_EX_rs1))
            forwardOp1 <= 2'b10;
        
        if      (EX_MEM_rd !=0 && regWrite_EX_MEM && (EX_MEM_rd == ID_EX_rs2))
            forwardOp2  <= 2'b01;
        else if (MEM_WB_rd !=0 && regWrite_MEM_WB && (MEM_WB_rd == ID_EX_rs2))
            forwardOp2 <= 2'b10;

    end

endmodule