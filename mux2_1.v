module mux2_1(
  input i0,
  input i1,
  input select,
  output reg out
);
  
  always @ (*)
    case (select)
      1'b0: out = i0;
      1'b1: out = i1;
    endcase
  
endmodule