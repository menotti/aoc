# Toolchains
CC = gcc
RISCV_PREFIX = riscv64-linux-gnu
AS = $(RISCV_PREFIX)-as
LD = $(RISCV_PREFIX)-ld
OBJDUMP = $(RISCV_PREFIX)-objdump

# Flags
CFLAGS = -Wall -O2

# Arquivos
ASM = riscv.asm
OBJ = riscv.o
ELF = riscv.elf
DUMP = riscv.dump
TXT = riscv.txt
GEN = encoding
SRC = main.c

# Alvo padrão
all: $(TXT)

# Compila o programa C
$(GEN): $(SRC)
	$(CC) $(CFLAGS) -o $@ $<

# Gera riscv.txt chamando o programa
$(TXT): $(GEN) $(ASM)
	./$(GEN)

# Limpeza
clean:
	rm -f $(GEN) $(OBJ) $(ELF) $(DUMP) $(TXT)
