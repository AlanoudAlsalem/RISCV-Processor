module EX_MEM(
    input clk, reset,
    input regWrite_in, memtoReg_in, memWrite_in, sb_in, lh_in, zeroFlag_in,
    input [1:0] branch_in, 
    input [31:0] readData2_in, ALUresult_in,
    input [4:0] rd_in,

    output reg regWrite, memtoReg, memWrite, sb, lh, zeroFlag,
    output reg [1:0] branch, 
    output reg [31:0] readData2, ALUresult,
    output reg [4:0] rd
);

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            regWrite    <= 0;
            memtoReg    <= 0;
            memWrite    <= 0;
            sb          <= 0;
            lh          <= 0;
            zeroFlag    <= 0;
            branch      <= 0;
            readData2   <= 0;
            ALUresult   <= 0;
            rd          <= 0;
        end
        else begin
            regWrite    <= regWrite_in;
            memtoReg    <= memtoReg_in;
            memWrite    <= memWrite_in;
            sb          <= sb_in;
            lh          <= lh_in;
            zeroFlag    <= zeroFlag_in;
            branch      <= branch_in;
            readData2   <= readData2_in;
            ALUresult   <= ALUresult_in;
            rd          <= rd_in;
        end
    end

endmodule