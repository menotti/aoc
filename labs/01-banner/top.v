module top(
    input CLOCK_50, // 50 MHz clock
    output [9:0] LEDR);

    integer counter;

    always @(posedge CLOCK_50) 
        counter <= counter + 1;

    rom my_rom (
        .address(counter[3:0]), // Try it out 
        .data_out(LEDR)
    );
endmodule