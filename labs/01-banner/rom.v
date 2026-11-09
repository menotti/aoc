module rom(
    input [3:0] address, 
    output [9:0] data_out);

    reg [9:0] memory [0:15]; // 16 words of 10 bits memory

    initial
        $readmemb("rom.bin", memory); // Load initial values from a text binary file

    assign data_out = memory[address]; // Asynchronous read from memory
endmodule