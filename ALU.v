// The 64-bit ALU performs computations based on the input operation

module ALU(
    input [2:0] operation, // 4-bit operation
    input [31:0] operand1, // 64-bit operand
    input [31:0] operand2, //64-bit operand
    output reg [31:0] result, // 64-bit result
    output reg zeroFlag // used for branch instructions
);

parameter add = 3'b000,
        sub = 3'b001,
        mul = 3'b010,
        div = 3'b011,
        shiftLeft = 3'b100,
        shiftRight = 3'b101;

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
                zeroFlag = 1;
            end
            mul: begin
                result = operand1 * operand2;
                if(result == 0)
                zeroFlag = 1;
            end
            div: begin
                result = operand1 / operand2;
                if(result == 0)
                zeroFlag = 1;
            end
            shiftLeft: begin
                result = operand1 <<< operand2;
                if(result == 0)
                zeroFlag = 1;
            end
            shiftRight: begin
                result = operand1 >>> operand2;
                if(result == 0)
                zeroFlag = 1;
            end
             default: begin //if operation is not defined 
                result = 0; 
                zeroFlag = 1; 
            end
        endcase
    end
endmodule




module ALU_testbench();
    reg[31:0] operand1;
    reg[31:0] operand2;
    reg[2:0] operation;
    wire zeroFlag;
    wire[31:0] result; 

    ALU ALU_instance(
        .operand1(operand1), .operand2(operand2), .operation(operation), .zeroFlag(zeroFlag), .result(result)); //connect testbench signals

    initial begin
        // ADD 
        operand1 = 32'b1; operand2= 32'b10; operation = 3'b000; #10;
        $display("ADD: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");

        // SUB 
        operand1 = 32'b1; operand2= 32'b10; operation = 3'b001; #10;
        $display("SUB: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");

         // MUL
        operand1 = 32'b1; operand2= 32'b10; operation = 3'b010; #10;
        $display("MUL: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");

         // DIV
        operand1 = 32'b1; operand2= 32'b10; operation = 3'b011 ; #10;
        $display("DIV: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");

        // SL
        operand1 = 32'b1; operand2= 32'b10; operation = 3'b100 ; #10;
        $display("SL: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");

        // SR
        operand1 = 32'b1; operand2= 32'b10; operation = 3'b101 ; #10;
        $display("SR: Time=%0t, operand1=%h, operand2=%h, operation=%b, result=%h, zeroFlag=%b",
        $time, operand1, operand2, operation, result, zeroFlag);
        $display("----------------------------------------");
    end

endmodule 
