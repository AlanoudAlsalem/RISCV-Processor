module MEM_WB(
    input clock, reset,
    input regWrite_in, memtoReg_in, lh_in, 
    input [31:0] ALUresult_in, data_in,
    input [4:0] rd_in,
    input halt_in,

    output reg regWrite, memtoReg, lh, 
    output reg [31:0] ALUresult, data,
    output reg [4:0] rd,
    output reg halt
);

    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            regWrite    <= 0;
            memtoReg    <= 0;
            lh          <= 0;
            data        <= 0;
            ALUresult   <= 0;
            rd          <= 0;
            halt        <= 0;
        end
        else begin
            regWrite    <= regWrite_in;
            memtoReg    <= memtoReg_in;
            lh          <= lh_in;
            data        <= data_in;
            ALUresult   <= ALUresult_in;
            rd          <= rd_in;
            halt        <= halt_in;
        end
    end

endmodule