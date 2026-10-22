module rom (
  input  logic [31:0] a,
  output logic [31:0] rd);

  logic  [31:0] ROM [0:255];

  // initialize memory with instructions
  initial begin
    ROM[ 0] = 32'h00400413; // li s0, 4
    ROM[ 1] = 32'h10c00493; // li s1, 0x0000010C
    ROM[ 2] = 32'hFFC42283; // lw t0, -4(s0)
    ROM[ 3] = 32'h00042303; // lw t1, (s0)
    ROM[ 4] = 32'h005303B3; // add t2, t1, t0 (loop:)
    ROM[ 5] = 32'h006002B3; // add t0, zero, t1
    ROM[ 6] = 32'h00700333; // add t1, zero, t2
    ROM[ 7] = 32'h00440413; // addi s0, s0, 4
    ROM[ 8] = 32'h00742023; // sw t2, (s0)
    ROM[ 9] = 32'h0074a023; // sw t2, (s1)
    ROM[10] = 32'hFE9FF06F; // j loop
  end

  assign rd = ROM[a[31:2]]; // word aligned
endmodule