module PC (
    input address,
    output reg readAddress,
);

    always @ (address)
        readAddress = address;

endmodule