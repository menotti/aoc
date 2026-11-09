module test; 
  reg clk, reset;
  reg [9:0] LEDR;       // memory-mapped I/O register for LEDR
  reg [23:0] hex_digits; // memory-mapped I/O register for HEX
  wire memwrite;
  wire [31:0] pc, instr;
  wire [31:0] writedata, addr, readdata;

  initial begin
    clk = 0; reset = 1;
    $dumpfile("dump.vcd");
    $dumpvars(0, test);
    #20 reset = 0;
    #3000 $finish;
  end

  initial 
    forever #5 clk = ~clk;

  // microprocessor
  riscvmono cpu(clk, reset, pc, instr, addr, writedata, memwrite, readdata);

  // instructions memory 
  rom instr_mem(pc, instr);

  // data memory 
  ram data_mem(clk, memwrite & isRAM, addr, writedata, readdata);

  // memory-mapped i/o
  wire isIO  = addr[8]; // 0x0000_0100
  wire isRAM = !isIO;
  localparam IO_LEDS_bit = 2; // 0x0000_0104
  localparam IO_HEX_bit  = 3; // 0x0000_0108
  always @(posedge clk)
    if (memwrite & isIO) begin // memory-mapped I/O
      if (addr[IO_LEDS_bit])
        LEDR <= writedata;
      if (addr[IO_HEX_bit])
        hex_digits <= writedata;
  end
endmodule
