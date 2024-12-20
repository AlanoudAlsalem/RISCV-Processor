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
    // opCodes             // funct3
    addiwOp     = 7'h13,    addiwf3 = 3'h0, 
    andiOp      = 7'h1B,    andif3  = 3'h6,
    jalrOp      = 7'h67,    jalrf3  = 3'h0, 
    lhOp        = 7'h03,    lhf3    = 3'h2,
    lwOp        = 7'h03,    lwf3    = 3'h0,
    oriOp       = 7'h13,    orif3   = 3'h7,
    
    // SB, UJ, U, and S-types
    // opCodes             // funct3
    beqOp       = 7'h63,    beqf3   = 3'h0,
    bneOp       = 7'h63,    bnef3   = 3'h1,
    jalOp       = 7'h6F,    
    luiOp       = 7'h38,
    sbOp        = 7'h23,    sbf3    = 3'h0,
    swOp        = 7'h23,    swf3    = 3'h2,
    //ALU operations
    addop       = 4'b0001,
    subop       = 4'b0010,
    andop       = 4'b0011,
    orop        = 4'b0100,
    sllop       = 4'b0101,
    srlop       = 4'b0110,
    xorop       = 4'b0111,
    sltop       = 4'b1000,
    jalop       = 4'b1001,
    luiop       = 4'b1010,
    // branch signals
    beqSig  = 2'b01,
    bneSig  = 2'b10,
    jSig    = 2'b11
)

(   input [6:0] opCode,      // 7-bit opCode
    input [2:0] funct3,      // 3-bit funct3
    input [6:0] funct7,      // 7-bit funct7
    output reg regWrite,     // register file write signal (1 = enable)
    output reg memtoReg,     // WB stage MUX selecion signal (0 = data, 1 = ALUresult)
    output reg memWrite,     // memory write signal = (memory read)'
    output reg [1:0] branch, // branch signal
    output reg [1:0] ALUsrc, // ALU operand 2 MUX selection signal (0 = Rs2, 1 = imm, 2 = PC)
    output reg [3:0] ALUop,  // ALU operation
    output reg sb,           // sb instruction
    output reg halt          // halts the CPU operation 
);
        
    always @ (*) begin
        // initializing the signals
        regWrite    <= 1'b0; 
        memtoReg    <= 1'b0; 
        memWrite    <= 1'b0; 
        branch      <= 2'b0; 
        ALUsrc      <= 2'b0; 
        ALUop       <= 4'b0;
        sb          <= 1'b0;
        halt        <= 1'b0;

        if(opCode == Rtype) begin
            regWrite    <= 1'b1; 
            memtoReg    <= 1'b1; 
            memWrite    <= 1'b0; 
            branch      <= 2'b0; 
            ALUsrc      <= 2'b0; 
        
            // assigns the ALUop signal
            case({funct3, funct7})
                {addwf3, addwf7}: ALUop <= addop;
                {andf3, andf7}  : ALUop <= andop;
                {xorf3, xorf7}  : ALUop <= xorop;
                {orf3, orf7}    : ALUop <= orop;
                {sltf3, sltf7}  : ALUop <= sltop;
                {sllf3, sllf7}  : ALUop <= sllop;
                {srlf3, srlf7}  : ALUop <= srlop;
                {subf3, subf7}  : ALUop <= subop; 
                default         : regWrite <= 1'b0; // for invalid funct3 and funct 7
            endcase
        end
        else if(opCode == addiwOp) begin
            regWrite    <= 1'b1; 
            memtoReg    <= 1'b1; 
            memWrite    <= 1'b0; 
            branch      <= 2'b0; 
            ALUop       <= addop;
            ALUsrc      <= 2'b1; 
        end
        else if(opCode == andiOp) begin
            regWrite    <= 1'b1; 
            memtoReg    <= 1'b1; 
            memWrite    <= 1'b0; 
            branch      <= 2'b0; 
            ALUop       <= andop;
            ALUsrc      <= 2'b1; 
        end
        else if(opCode == jalrOp) begin
            regWrite    <= 1'b1; 
            memtoReg    <= 1'b1; 
            memWrite    <= 1'b0; 
            branch      <= jSig; 
            ALUop       <= jalop;
            ALUsrc      <= 2'b1; 
        end
        else if(opCode == lhOp) begin
            regWrite    <= 1'b1; 
            memtoReg    <= 1'b0; 
            memWrite    <= 1'b0; 
            branch      <= 2'b0; 
            ALUop       <= addop;
            ALUsrc      <= 2'b1; 
        end
        else if(opCode == lwOp) begin
            regWrite    <= 1'b1; 
            memtoReg    <= 1'b0; 
            memWrite    <= 1'b0; 
            branch      <= 2'b0; 
            ALUop       <= addop;
            ALUsrc      <= 2'b1; 
        end
        else if(opCode == oriOp) begin
            regWrite    <= 1'b1; 
            memtoReg    <= 1'b1; 
            memWrite    <= 1'b0; 
            branch      <= 2'b0; 
            ALUop       <= orop;
            ALUsrc      <= 2'b1;
        end
        else if(opCode == beqOp) begin
            regWrite    <= 1'b0; 
            memWrite    <= 1'b0;  
            ALUop       <= subop;
            ALUsrc      <= 2'b0;
            branch      <= (opCode == beqOp) ? beqSig : bneSig;
        end
        else if(opCode == jalOp) begin
            regWrite    <= 1'b1; 
            memtoReg    <= 1'b1; 
            memWrite    <= 1'b0; 
            branch      <= jSig; 
            ALUop       <= jalop;
            ALUsrc      <= 2'b10;
        end
        else if(opCode == luiOp) begin
            regWrite    <= 1'b1; 
            memtoReg    <= 1'b0; 
            memWrite    <= 1'b0; 
            branch      <= 2'b0; 
            ALUop       <= luiop;
            ALUsrc      <= 2'b1;
        end
        else if(opCode == sbOp) begin
            regWrite    <= 1'b0; 
            memWrite    <= 1'b1; 
            branch      <= 2'b0; 
            ALUop       <= addop;
            ALUsrc      <= 2'b1;
            sb          <= (funct3 == 0) ? 1 : 0;
        end
        else if(opCode == 7'h0) 
            halt <= 1;
    end       
endmodule 