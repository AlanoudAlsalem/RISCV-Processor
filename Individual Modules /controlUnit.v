module controlUnit
// categorizes the instrucion types and ALU operations
# (parameter
        // R-types
        Rtype       = 7'h33,    // opCode
        // funct3               // funct 7
        addwf3      = 3'h1,     addwf7  = 7'h20,
        andf3       = 3'h7,     andf7   = 7'h0,
        xorf3       = 3'h3,     xorf7   = 7'h0,
        orf3        = 3'h5,     orf7    = 7'h0,  
        sltf3       = 3'h0,     sltf7   = 7'h0,
        sllf3       = 3'h4,     sllf7   = 7'h0,
        srlf3       = 3'h2,     srlf7   = 7'h0,
        subf3       = 3'h6,     subf7   = 7'h0,
        
        // I-types
        // op codes             // funct3
        addiwOP     = 7'h13,    addiwf3 = 3'h0, 
        andiOP      = 7'h1B,    andif3  = 3'h6,
        jalrOP      = 7'h67,    jalrf3  = 3'h0, 
        lhOP        = 7'h3,     lhf3    = 3'h2,
        lwOP        = 7'h3,     lwf3    = 3'h0,
        oriOP       = 7'h13,    orif3   = 3'h7,
         

        //ALU operations
        addop       = 3'b000,
        subop       = 3'b001,
        andop       = 3'b010,
        orop        = 3'b011,
        sllop       = 3'b100,
        srlop       = 3'b101,
        xorop       = 3'b110,
        sltop       = 3'b111
    )

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
                    {addwf3, addwf7}: ALUop <= addop;
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
            luItype: begin
                regWrite    <= 0; // disables writeback on register file
                memWrite    <= 1; // enables writing on memory

                // assigns the ALUop signal
                ALUop <= addop;
            end
            default: begin
                regWrite    <= 0; // disables writeback on register file
                memWrite    <= 0; // disables writing on memory
            end
        endcase
    end 
endmodule 

module controlUnit_testbench;
    reg [6:0] opCode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire regWrite;
    wire memWrite;
    wire [2:0] ALUop;

    controlUnit DUT(
        .opCode(opCode),
        .funct3(funct3),
        .funct7(funct7),
        .regWrite(regWrite),
        .memWrite(memWrite),
        .ALUop(ALUop)
    );

    initial begin
        opCode <= 7'b0100001;
        funct3 <= 3'b001;
        funct7 <= 7'b0010100;
        #5
        $display("regWrite = %b, memWrite = %b, ALUop = %b", regWrite, memWrite, ALUop);
    end
endmodule

