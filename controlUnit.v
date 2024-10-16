module controlUnit
// categorizes the instrucion types and ALU operations
# ( parameter  
        // R-types
        Rtype   = 7'b0110011,   // opcode
        addf3   = 3'b000,   addf7   = 7'b0000000,  
        subf3   = 3'b000,   subf7   = 7'b0100000,
        orf3    = 3'b110,   orf7    = 7'b0000000,
        andf3   = 3'b111,   andf7   = 7'b0000000,
        // I-types
        Itype   = 7'b0010011,   // opcode
        addif3  = 3'b000, 
        orif3   = 3'b110,
        andif3  = 3'b111,
        // stores and loads
        sw      = 7'b0100011,   // opcode
        swf3    = 3'b010,
        lw      = 7'b0000011,
        lwf3    = 3'b010,
        //ALU operations
        addop   = 3'b000,
        subop   = 3'b001,
        andop   = 3'b010,
        orop    = 3'b011 )

(   input [6:0] opCode, // 7-bit opCode
    input [2:0] funct3, // 3-bit funct3
    input [6:0] funct7, // 7-bit funct7
    output reg regWrite, // register file write signal
    output reg memWrite, // memory write signal = (memory read)'
    output reg [2:0] ALUop // ALU operation
);
        
    always @ (*) begin
        case(opCode)
            Rtype: begin
                regWrite    <= 1; // enables writeback on register file
                memWrite    <= 0; // disables writing on memory
            
                // assigns the ALUop signal
                case({funct3, funct7})
                    {addf3, addf7}  : ALUop <= addop;
                    {subf3, subf7}  : ALUop <= subop;
                    {orf3, orf7}    : ALUop <= orop;
                    {andf3, andf7}  : ALUop <= andop;
                endcase // R-type {funct3, funct7}
            end
            Itype: begin
                regWrite    <= 1; // enables writeback on register file
                memWrite    <= 0; // disables writing on memory

                // assigns the ALUop signal
                case(funct3)
                    addif3  : ALUop <= addop;
                    orif3   : ALUop <= orop;
                    andif3  : ALUop <= andop;
                endcase // I-type funct3
            end
            sw: begin
                regWrite    <= 0; // disables writeback on register file
                memWrite    <= 1; // enables writing on memory
            end
            lw: begin
                regWrite    <= 1; // enables writeback on register file
                memWrite    <= 0; // disables writing on memory
            end
            default: begin
                regWrite    <= 0; // disables writeback on register file
                memWrite    <= 0; // disables writing on memory
            end
        endcase
    end 
endmodule 