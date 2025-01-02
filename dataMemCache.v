module dataMemory(
    input [31:0] dataAddress,
    input [31:0] writeData,
    input memWrite,
    input sb,
    output reg [31:0]   data1,  data2,  data3,  data4,
                        data5,  data6,  data7,  data8,
                        data9,  data10, data11, data12,
                        data13, data14, data15, data16

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

    assign data1    = {memory[dataAddress + 3],     memory[dataAddress + 2],    memory[dataAddress + 1],    memory[dataAddress]};
    assign data2    = {memory[dataAddress + 7],     memory[dataAddress + 6],    memory[dataAddress + 5],    memory[dataAddress + 4]};
    assign data3    = {memory[dataAddress + 11],    memory[dataAddress + 10],   memory[dataAddress + 9],    memory[dataAddress + 8]};
    assign data4    = {memory[dataAddress + 15],    memory[dataAddress + 14],   memory[dataAddress + 13],   memory[dataAddress + 12]};
    assign data5    = {memory[dataAddress + 19],    memory[dataAddress + 18],   memory[dataAddress + 17],   memory[dataAddress + 16]};
    assign data6    = {memory[dataAddress + 23],    memory[dataAddress + 22],   memory[dataAddress + 21],   memory[dataAddress + 20]};
    assign data7    = {memory[dataAddress + 27],    memory[dataAddress + 26],   memory[dataAddress + 25],   memory[dataAddress + 24]};
    assign data8    = {memory[dataAddress + 31],    memory[dataAddress + 30],   memory[dataAddress + 29],   memory[dataAddress + 28]};
    assign data9    = {memory[dataAddress + 35],    memory[dataAddress + 34],   memory[dataAddress + 33],   memory[dataAddress + 32]};
    assign data10   = {memory[dataAddress + 39],    memory[dataAddress + 38],   memory[dataAddress + 37],   memory[dataAddress + 36]};
    assign data11   = {memory[dataAddress + 43],    memory[dataAddress + 42],   memory[dataAddress + 41],   memory[dataAddress + 40]};
    assign data12   = {memory[dataAddress + 47],    memory[dataAddress + 46],   memory[dataAddress + 45],   memory[dataAddress + 44]};
    assign data13   = {memory[dataAddress + 51],    memory[dataAddress + 50],   memory[dataAddress + 49],   memory[dataAddress + 48]};
    assign data14   = {memory[dataAddress + 55],    memory[dataAddress + 54],   memory[dataAddress + 53],   memory[dataAddress + 52]};
    assign data15   = {memory[dataAddress + 59],    memory[dataAddress + 58],   memory[dataAddress + 57],   memory[dataAddress + 56]};

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