loop:
    add x3, x2, x1
    sub x3, x2, x1
    sra x3, x2, x1
    xor x3, x2, x1

    addi x3, x2, 4
    slli x3, x2, 4
    xori x3, x2, 4
    lw x3, 4(sp)
    lh x3, 4(sp)
    lhu x3, 4(sp)
    lb x3, 4(sp)
    lbu x3, 4(sp)
    sw x3, 0(sp)
    beq x1, x10, loop
    lui x10, 0xcafe
    auipc x1, 0xbabe
    jal loop
    jalr x2, x3, -4
    ecall 
    ebreak 