module dataMemory(
    input [31:0] dataAddress,
    input [31:0] writeData,
    input memWrite,
    input sb,
    output reg [31:0] data
);

    reg [7:0] memory [8191:0]; // 8K memory locations with 8 bits in each location

    // initializing data
    initial begin 
        memory[0]   <= 8'h1;
        memory[1]   <= 8'h0;
        memory[2]   <= 8'h0;
        memory[3]   <= 8'h0;

        memory[4]   <= 8'h02;
        memory[5]   <= 8'hf0;
        memory[6]   <= 8'h00;
        memory[7]   <= 8'hf0;

        memory[8]   <= 8'h3;
        memory[9]   <= 8'h0;
        memory[10]  <= 8'h0;
        memory[11]  <= 8'h0;

        memory[12]  <= 8'h4;
        memory[13]  <= 8'h0;
        memory[14]  <= 8'h0;
        memory[15]  <= 8'h0;
    end

    always @ (*) begin
        if(memWrite) begin
            if(sb)
                memory[dataAddress] <= writeData[7:0];
            else begin // stores the data in little endian format
                memory[dataAddress] <= writeData[7:0];
                memory[dataAddress] <= writeData[15:8];
                memory[dataAddress] <= writeData[23:16];
                memory[dataAddress] <= writeData[31:24];
            end
        end
        else    
            data = {
            memory[dataAddress + 3], 
            memory[dataAddress + 2], 
            memory[dataAddress + 1], 
            memory[dataAddress]
            };
    end
endmodule