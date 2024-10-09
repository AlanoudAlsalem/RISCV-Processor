`include "mux2_1.v"
`include "instructionMemory.v"
`include "PC.v"
`include "immGen.v"

module testbench;
    reg [31:0] in_t;
    wire [63:0] out_t;

    immGen m1(in_t, out_t);

    initial begin 
        $display ("Immediate generator:");
        in_t = 32'd567;
        #1 $display("%b -> %b", in_t, out_t);
        in_t = -32'b01;
        #1 $display("%b -> %b", in_t, out_t);

    end

endmodule