`include "mux2_1.v"

module testbench;
    reg in0, in1, sel;
    wire out;

    mux2_1 m1(in0, in1, sel, out);

    initial begin 
        in0=0; in1=1; sel=0;
        #1 $display("%b", out);
        sel=1;
        #1 $display("%b", out);
    end 

endmodule