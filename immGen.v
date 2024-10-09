// The immediate generator sign extends the 32-bit input to a 64-bit output

module immGen(
    input [31:0] in,
    output reg [63:0] out
);

    always @ (in)
     out = in[31] ? {32'hFFFFFFFF, in} : {32'h00000000, in};

endmodule