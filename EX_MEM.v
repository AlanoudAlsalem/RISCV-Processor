module EX_MEM(
    input clock, reset,
    input regWrite_in, memtoReg_in, memWrite_in, sb_in, lh_in, ld_in,
    input [31:0] readData2_in, ALUresult_in,
    input [4:0] rd_in,
    input halt_in,

    output reg regWrite, memtoReg, memWrite, sb, lh, ld,
    output reg [31:0] readData2, ALUresult,
    output reg [4:0] rd,
    output reg halt
);

    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            regWrite    <= 0;
            memtoReg    <= 0;
            memWrite    <= 0;
            sb          <= 0;
            lh          <= 0;
            ld          <= 0;
            readData2   <= 0;
            ALUresult   <= 0;
            rd          <= 0;
            halt        <= 0;
        end
        else begin
            regWrite    <= regWrite_in;
            memtoReg    <= memtoReg_in;
            memWrite    <= memWrite_in;
            sb          <= sb_in;
            lh          <= lh_in;
            ld          <= ld_in;
            readData2   <= readData2_in;
            ALUresult   <= ALUresult_in;
            rd          <= rd_in;
            halt        <= halt_in;
        end
    end

endmodule