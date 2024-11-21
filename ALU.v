// The 64-bit ALU performs computations based on the input operation

module ALU(
    input [6:0] operation, // 4-bit operation
    input [31:0] operand1, // 64-bit operand
    input [31:0] operand2, //64-bit operand
    output reg [31:0] result, // 64-bit result
    output reg zeroFlag // used for branch instructions
);

    parameter 
    4'b0000 = add,
    4'b0001 = sub,
    4'b0010 = mul,
    4'b0011 = div,
    4'b0100 = shiftLeft,
    4'b0101 = shiftRight;

    always @ (*) begin
        zeroFlag = 0;
        case(operation)
            add: begin
                result = operand1 + operand2;
                if(result == 0)
                    zeroFlag = 0;
            end
            sub: begin
                result = operand1 - operand2;
                if(result == 0)
                zeroFlag == 0;
            end
            mul: begin
                result = operand1 * operand2;
                if(result == 0)
                zeroFlag == 0;
            end
            div: begin
                result = operand1 / operand2;
                if(result == 0)
                zeroFlag == 0;
            end
            shiftLeft: begin
                result = operand1 <<< operand2;
                if(result == 0)
                zeroFlag == 0;
            end
            shiftRight: begin
                result = operand1 >>> operand2;
                if(result == 0)
                zeroFlag == 0;
            end
             default: begin //if operation is not defined 
                result = 0; 
                zeroFlag = 1; 
            end
        endcase
    end
endmodule

module ALU_testbench();
    reg[63:0] operand1;
    reg[63:0] operand2;
    reg[3:0] operation;
    wire zeroFlag;
    wire[63:0] result; 

    ALU ALU_instance(operand1, operand2, operation, zeroFlag, result); //connect testbench signals
    reg clk = 0;
    always #5 clk = ~clk; //toggle every five time units

    initial begin
        // ADD 
        operand1 = 16'hFFFF; operand2= 4'h2; operation = 4'b0000; #10;
        $display("ADD: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");

        // SUB 
        operand1 = 16'h00FF; operand2= 4'h3; operation = 4'b0001; #10;
        $display("SUB: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");

         // MUL
        operand1 = 16'h000F; operand2= 16'h0010; operation = 4'b0010; #10;
        $display("SUB: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");

         // DIV
        operand1 = 16'hFFFF; operand2= 16'h0F0F; operation = 4'b0011 ; #10;
        $display("SUB: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");

        // SL
        operand1 = 16'h00FF; operand2= 16'h0010; operation = 4'b0100 ; #10;
        $display("SUB: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");

        // SR
        operand1 = 16'h00FF; operand2= 16'h0F0F; operation = 4'b0101 ; #10;
        $display("SUB: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");
    end

endmodule 
