module controlUnit
// categorizes the instrucion types and ALU operations
# ( parameter  
        // R-types
        Rtype   = 7'b0100001,   // opcode
        addwordf3   = 3'b001,   addwordf7   = 7'b0010100,  
        subf3   = 3'b110,   subf7   = 7'b0000000,
        orf3    = 3'b101,   orf7    = 7'b0000000,
        andf3   = 3'b111,   andf7   = 7'b0000000,
        xorf3   = 3'b011,   xorf7   = 7'b0000000,
        setltf3   = 3'b000,   sltf7   = 7'b0000000,
        shiftlf3   = 3'b100,   andf7   = 7'b0000000,
        shiftrf3   = 3'b010,   andf7   = 7'b0000000,
        
        // I-types
        Itype   = 7'b0001101,   // opcode
        addiwf3  = 3'b000, 
        orif3   = 3'b111,
        andif3  = 3'b110, 
        
        //jalr I type 
        Ijtype   = 7'b1000011,   // opcode
        jalrf3  = 3'b000, 

        //uj type
        ujtype   = 7'b1101111,   // opcode

        //SB type 
        sbtype  = 7'b01111111,   // opcode
        beqf3  = 3'b000,
        bnef3  = 3'b001,  

        // stores
        sw      = 7'b0010111,   // opcode
        swBf3    = 3'b000,
        swWf3    = 3'b010,

        // loads
        lw      = 7'b0000011,
        lwHf3    = 3'b010,
        lwWf3    = 3'b000,

        // load upper
        luI      = 7'b0100100,

        //ALU operations
        addop   = 3'b000,
        subop   = 3'b001,
        andop   = 3'b010,
        orop    = 3'b011
        sllop   = 3'b100,
        srlop   = 3'b101,
        xorop   = 3'b110,
        sltop   = 3'b111, )

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
                    {xorf3, xorf7}  : ALUop <= xorop;
                    {sltf3, sltf7}  : ALUop <= sltop;
                    {xorf3, xorf7}  : ALUop <= xorop;
                    {sllf3, sllf7}  : ALUop <= sllop;
                    {srlf3, srlf7}  : ALUop <= srlop;
                endcase // R-type {funct3, funct7}
            end
            Itype: begin
                regWrite    <= 1; // enables writeback on register file
                memWrite    <= 0; // disables writing on memory

                // assigns the ALUop signal
                case(funct3)
                    addiwf3  : ALUop <= addop;
                    orif3   : ALUop <= orop;
                    andif3  : ALUop <= andop;
                endcase // I-type funct3
            end
            sw: begin
                regWrite    <= 0; // disables writeback on register file
                memWrite    <= 1; // enables writing on memory

                // assigns the ALUop signal
                case(funct3)
                    swBf3  : ALUop <= addop;
                    swWf3   : ALUop <= addop;
                endcase // sw-type funct3
            end
            lw: begin
                regWrite    <= 1; // enables writeback on register file
                memWrite    <= 0; // disables writing on memory

                // assigns the ALUop signal
                case(funct3)
                    lwHf3  : ALUop <= addop;
                    lwWf3   : ALUop <= addop;
                endcase // lw-type funct3
            end
            sbtype: begin
                regWrite    <= 0; // disables writeback on register file
                memWrite    <= 1; // enables writing on memory

                // assigns the ALUop signal
                case(funct3)
                    beqf3  : ALUop <= subop;
                    bnef3   : ALUop <= subop;
                endcase // sb-type funct3
            end
            sbtype: begin
                regWrite    <= 0; // disables writeback on register file
                memWrite    <= 1; // enables writing on memory

                // assigns the ALUop signal
                case(funct3)
                    luif3  : ALUop <= sllop;
                endcase // u-type funct3
            end
            ujtype: begin
                regWrite    <= 0; // disables writeback on register file
                memWrite    <= 1; // enables writing on memory

                // assigns the ALUop signal
                case(funct3)
                    jalf3  : ALUop <= addop;
                endcase // uj-type funct3
            end
            Ijtype: begin
                regWrite    <= 0; // disables writeback on register file
                memWrite    <= 1; // enables writing on memory

                // assigns the ALUop signal
                case(funct3)
                    jalrf3  : ALUop <= addop;
                endcase // i-type funct3
            end
            default: begin
                regWrite    <= 0; // disables writeback on register file
                memWrite    <= 0; // disables writing on memory
            end
            luItype: begin
                regWrite    <= 0; // disables writeback on register file
                memWrite    <= 1; // enables writing on memory

                // assigns the ALUop signal
                    jalrf3  : ALUop <= addop;
            end
        endcase
    end 
endmodule 