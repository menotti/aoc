_start:
    # R-type: registradores
    add     x5, x1, x2         # R: rd=x5, rs1=x1, rs2=x2, funct3=000, funct7=0000000
    xor     x4, x2, x3         # R: rd=x4, rs1=x2, rs2=x3, funct3=100, funct7=0000000
    # I-type (aritmético imediato)
    addi    x6, x5, 42         # I: rd=x6, rs1=x5, imm=42, funct3=000
    slli    x5, x6, 3          # I: rd=x5, rs1=x6, shamt=3, funct3=001
    # I-type (load)
    lw      x7, 64(x6)          # I: rd=x7, rs1=x6, imm=64, funct3=010
    lbu     x5, 32(x4)          # I: rd=x5, rs1=x4, imm=32, funct3=100
    # S-type: store
    sw      x7, 16(x5)         # S: rs1=x5, rs2=x7, imm=16, funct3=010
    sb      x6, 16(x2)         # S: rs1=x2, rs2=x6, imm=16, funct3=001
    # B-type: branch condicional
    beq     x5, x6, label      # B: rs1=x5, rs2=x6, imm=offset(label), funct3=000
    bne     x3, x4, label      # B: rs1=x3, rs2=x4, imm=offset(label), funct3=001
    # U-type: imediato alto
    lui     x8, 0xABCDE        # U: rd=x8, imm[31:12]=0xABCDE
    # J-type: salto
    jal     x1, end            # J: rd=x1 (ra), imm=offset(end)
label:
    addi    x9, x0, 7          # I: instrução após branch
end:
    nop                        # I-type: addi x0,x0,0
