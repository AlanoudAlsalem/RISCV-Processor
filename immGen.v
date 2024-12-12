// The immediate generator sign extends the 32-bit input to a 64-bit output

//dont we have to deal with every instruction type differently????
module immGen(
    input [31:0] in,
    output reg [63:0] out
);

    always @ (in)
    out = in[31] ? {32'hFFFFFFFF, in} : {32'h00000000, in};

endmodule

module stimulus();
    reg [31:0] in;
    wire [63:0] out;

    immGen gen(.in(in), .out(out));

    initial begin
        // Test case 1: I-Type (ADDI)
        in = 32'b00010000000000010000000010010011;
        #1;
        $display("Test case 1: Instruction = %b, Immediate = %b", in, out);
        
        in = 32'b00000001111000001000000010100011; 
        #1;
        $display("Test case 3: Instruction = %b, Immediate = %b", in, out);

        in = 32'b00000001111100001000000000111000; 
        #1;
        $display("Test case 4: Instruction = %b, Immediate = %b", in, out);

        in = 32'b00000010000000000000000001100011; 
        #1;
        $display("Test case 5: Instruction = %b, Immediate = %b", in, out);
        
        in = 32'b00000010000000000000000001101111; 
        #1;
        $display("Test case 5: Instruction = %b, Immediate = %b", in, out);
        
        $finish; // End simulation
    end
endmodule
