module pc_adder()
    input[31:0] address;
    output[31:0] NextAddress = address+4;
    //could overflow occur?

endmodule