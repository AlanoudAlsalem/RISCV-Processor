module ID_EX(
    input clk, reset,
    input regWrite_in, memtoReg_in, memWrite_in, sb_in, lh_in, 
    input [1:0] branch_in, 
    input [1:0] ALUsrc_in,
    input [3:0] ALUop_in,
    input [31:0] PC_in, readData1_in, readData2_in, immediate_in,
    input [4:0] rd_in,

    output reg regWrite, memtoReg, memWrite, sb, lh, 
    output reg [1:0] branch, 
    output reg [1:0] ALUsrc,
    output reg [3:0] ALUop,
    output reg [31:0] PC, readData1, readData2, immediate,
    output reg [4:0] rd
);


    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            regWrite    <= 0;
            memtoReg    <= 0;
            memWrite    <= 0;
            sb          <= 0;
            lh          <= 0;
            branch      <= 0;
            ALUsrc      <= 0;
            ALUop       <= 0;
            PC          <= 0;
            readData1   <= 0;
            readData2   <= 0;
            immediate   <= 0;
            rd          <= 0;
        end
        else begin
            regWrite    <= regWrite_in;
            memtoReg    <= memtoReg_in;
            memWrite    <= memWrite_in;
            sb          <= sb_in;
            lh          <= lh_in;
            branch      <= branch_in;
            ALUsrc      <= ALUsrc_in;
            ALUop       <= ALUop_in;
            PC          <= PC_in;
            readData1   <= readData1_in;
            readData2   <= readData2_in;
            immediate   <= immediate_in;
            rd          <= rd_in;
        end
    end

endmodule