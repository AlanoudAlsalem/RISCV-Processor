// extends the sign of the half-word loaded from a lh instruction
module signExtender(
    input lh,
    input [31:0] inputData,
    output [31:0] outputData
);

    assign outputData = (lh) ? {{16{inputData[31]}}, inputData[31:16]} : inputData; 

endmodule