#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    int ret;

    // 1. Assembler: compila riscv.asm em objeto RV32I
    ret = system("riscv64-linux-gnu-as -march=rv32i -mabi=ilp32 -o riscv.o riscv.asm");
    if (ret != 0) {
        fprintf(stderr, "Erro no assembler!\n");
        return 1;
    }

    // 2. Linker: gera executável bare-metal simples (ELF32)
    ret = system("riscv64-linux-gnu-ld -m elf32lriscv -Ttext=0x0 -o riscv.elf riscv.o");
    if (ret != 0) {
        fprintf(stderr, "Erro no linker!\n");
        return 1;
    }

    // 3. Dump: gera instruções em formato legível
    ret = system("riscv64-linux-gnu-objdump -d riscv.elf > riscv.dump");
    if (ret != 0) {
        fprintf(stderr, "Erro no objdump!\n");
        return 1;
    }

    // 4. Extrair instruções e escrever em binário
    FILE *fin = fopen("riscv.dump", "r");
    FILE *fout = fopen("riscv.txt", "w");
    if (!fin || !fout) {
        fprintf(stderr, "Erro abrindo arquivos!\n");
        return 1;
    }

    char line[256];
    while (fgets(line, sizeof(line), fin)) {
        unsigned int addr, instr;
        char mnemonic[64];

        // Exemplo de linha objdump:
        //    0:   00a585b3            add     a1,a1,a0
        if (sscanf(line, "%x:\t%x\t%s", &addr, &instr, mnemonic) == 3) {
            // Converte para binário 32 bits
            for (int i = 31; i >= 0; i--) {
                fprintf(fout, "%d", (instr >> i) & 1);
            }
            fprintf(fout, "\n");
        }
    }

    fclose(fin);
    fclose(fout);

    printf("Arquivo riscv.txt gerado com sucesso!\n");
    return 0;
}
