`include "CPU.v"

module testbench;
    reg clk, reset;
    wire [31:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8,
       reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16,
       reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24,
       reg25, reg26, reg27, reg28, reg29, reg30, reg31, reg32;

    reg [31:0] cycles = 0;

    CPU DUT(
        .clock(clk),
        .reset(reset),
        .reg1(reg1), .reg2(reg2), .reg3(reg3), .reg4(reg4),
        .reg5(reg5), .reg6(reg6), .reg7(reg7), .reg8(reg8),
        .reg9(reg9), .reg10(reg10), .reg11(reg11), .reg12(reg12),
        .reg13(reg13), .reg14(reg14), .reg15(reg15), .reg16(reg16),
        .reg17(reg17), .reg18(reg18), .reg19(reg19), .reg20(reg20),
        .reg21(reg21), .reg22(reg22), .reg23(reg23), .reg24(reg24),
        .reg25(reg25), .reg26(reg26), .reg27(reg27), .reg28(reg28),
        .reg29(reg29), .reg30(reg30), .reg31(reg31), .reg32(reg32)
    );

    initial begin
        clk = 0; reset = 0; #1 reset = 1; #4 reset = 0;
        repeat (32) begin
            #5 clk = ~clk;
        end
    end

    always @ (posedge clk) begin
        cycles = cycles + 1;
        $display("Cycle # %d", cycles);
        $display("Register file content:");
        $display("x0: %h\tx1: %h", reg1, reg2);
        $display("x2: %h\tx3: %h", reg3, reg4);
        $display("x4: %h\tx5: %h", reg5, reg6);
        $display("x6: %h\tx7: %h", reg7, reg8);
        $display("x8: %h\tx9: %h", reg9, reg10);
        $display("x10: %h\tx11: %h", reg11, reg12);
        $display("x12: %h\tx13: %h", reg13, reg14);
        $display("x14: %h\tx15: %h", reg15, reg16);
        $display("x16: %h\tx17: %h", reg17, reg18);
        $display("x18: %h\tx19: %h", reg19, reg20);
        $display("x20: %h\tx21: %h", reg21, reg22);
        $display("x22: %h\tx23: %h", reg23, reg24);
        $display("x24: %h\tx25: %h", reg25, reg26);
        $display("x26: %h\tx27: %h", reg27, reg28);
        $display("x28: %h\tx29: %h", reg29, reg30);
        $display("x30: %h\tx31: %h", reg31, reg32);
        $display("----------------------------------- %t -----------------------------------\n", $time);
    end

endmodule