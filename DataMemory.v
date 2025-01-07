module dataMemory(
    input [31:0] dataAddress,
    input [31:0] writeData,
    input memWrite, sb,
    output [31:0] data,
    output [31:0] m0,   m4,     m8,     m12,    m16,     
                  m20,  m24,    m28,    m32,    m36
);

    reg [7:0] memory [8191:0]; // 8K memory locations with 8 bits in each location

    assign m0   = {memory[3],     memory[2],      memory[1],      memory[0]};
    assign m4   = {memory[7],     memory[6],      memory[5],      memory[4]};
    assign m8   = {memory[11],    memory[10],     memory[9],      memory[8]};
    assign m12  = {memory[15],    memory[14],     memory[13],     memory[12]};
    assign m16  = {memory[19],    memory[18],     memory[17],     memory[16]};
    assign m20  = {memory[23],    memory[22],     memory[21],     memory[20]};
    assign m24  = {memory[27],    memory[26],     memory[25],     memory[24]};
    assign m28  = {memory[31],    memory[30],     memory[29],     memory[28]};
    assign m32  = {memory[35],    memory[34],     memory[33],     memory[32]};
    assign m36  = {memory[39],    memory[38],     memory[37],     memory[36]};

    // reading data
    assign data = {
            memory[dataAddress + 3], 
            memory[dataAddress + 2], 
            memory[dataAddress + 1], 
            memory[dataAddress]
            };

    // initializing data
    initial begin 
        memory[0]   <= 8'h0;
        memory[1]   <= 8'h0;
        memory[2]   <= 8'h0;
        memory[3]   <= 8'h0;

        memory[4]   <= 8'h0;
        memory[5]   <= 8'h0;
        memory[6]   <= 8'h0;
        memory[7]   <= 8'h0;

        memory[8]   <= 8'h0;
        memory[9]   <= 8'h0;
        memory[10]  <= 8'h0;
        memory[11]  <= 8'h0;

        memory[12]  <= 8'h0;
        memory[13]  <= 8'h0;
        memory[14]  <= 8'h0;
        memory[15]  <= 8'h0;

        memory[16]  <= 8'h0;
        memory[17]  <= 8'h0;
        memory[18]  <= 8'h0;
        memory[19]  <= 8'h0;

        memory[20]  <= 8'hA;
        memory[21]  <= 8'hB;
        memory[22]  <= 8'hC;
        memory[23]  <= 8'hD;

        memory[24]  <= 8'h0;
        memory[25]  <= 8'h0;
        memory[26]  <= 8'h0;
        memory[27]  <= 8'h0;

        memory[28]  <= 8'h0;
        memory[29]  <= 8'h0;
        memory[30]  <= 8'h0;
        memory[31]  <= 8'h0;

        memory[32]  <= 8'h64;
        memory[33]  <= 8'h0;
        memory[34]  <= 8'h0;
        memory[35]  <= 8'h0;

        memory[36]  <= 8'h0;
        memory[37]  <= 8'h0;
        memory[38]  <= 8'h0;
        memory[39]  <= 8'h0;
    end

    always @ (*) begin
        if(memWrite) begin
            if(sb)
                memory[dataAddress] <= writeData[7:0];
            else begin // stores the data in little endian format
                memory[dataAddress]     <= writeData[7:0];
                memory[dataAddress + 1] <= writeData[15:8];
                memory[dataAddress + 2] <= writeData[23:16];
                memory[dataAddress + 3] <= writeData[31:24];
            end
        end     
    end
endmodule