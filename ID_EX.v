module ID_EX(
    input clock, reset, nop, // do not let decoded instruction execute when nop
    input regWrite_in, memtoReg_in, memWrite_in, sb_in, lh_in, ld_in, halt_in,
    input [1:0] ALUsrc_in,
    input [3:0] ALUop_in,
    input [31:0] PC_in, readData1_in, readData2_in, immediate_in,
    input [4:0] rd_in, rs1_in, rs2_in,

    output reg regWrite, memtoReg, memWrite, sb, lh, ld, halt,
    output reg [1:0] ALUsrc,
    output reg [3:0] ALUop,
    output reg [31:0] PC, readData1, readData2, immediate,
    output reg [4:0] rd, rs1, rs2
);


    always @ (posedge clock or posedge reset) begin
        if (reset || nop) begin
            regWrite    <= 0;
            memtoReg    <= 0;
            memWrite    <= 0;
            sb          <= 0;
            lh          <= 0;
            ALUsrc      <= 0;
            ALUop       <= 0;
            PC          <= 0;
            readData1   <= 0;
            readData2   <= 0;
            immediate   <= 0;
            rd          <= 0;
            rs1         <= 0;
            rs2         <= 0;
            ld          <= 0;
            halt        <= 0;
        end
        else begin
            regWrite    <= regWrite_in;
            memtoReg    <= memtoReg_in;
            memWrite    <= memWrite_in;
            sb          <= sb_in;
            lh          <= lh_in;
            ALUsrc      <= ALUsrc_in;
            ALUop       <= ALUop_in;
            PC          <= PC_in;
            readData1   <= readData1_in;
            readData2   <= readData2_in;
            immediate   <= immediate_in;
            rd          <= rd_in;
            rs1         <= rs1_in;
            rs2         <= rs2_in;
            ld          <= ld_in;
            halt        <= halt_in;
        end
    end

endmodule