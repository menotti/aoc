#!/usr/bin/env python3
import re
import sys
import pathlib
import tempfile
import subprocess
from unittest import case

def run(cmd):
    return subprocess.check_output(cmd, stderr=subprocess.STDOUT).decode()

def normalize_asm(s):
    s = re.sub(r"\s+", " ", s)
    return s.strip()

def split_asm(s):
    parts = s.split(" ", 1)
    mnemonic = parts[0]
    operands = parts[1] if len(parts) > 1 else ""
    return mnemonic, operands

def decode_r_type(instr):
    return [
        ("funct7",     instr[ 0: 7], 21),
        ("rs2",        instr[ 7:12], 14),
        ("rs1",        instr[12:17], 10),
        ("funct3",     instr[17:20],  7),
        ("rd",         instr[20:25], 17),
        ("opcode",     instr[25:32],  7),
    ]

def decode_i_type(instr):
    return [
        ("imm[11:0]",  instr[ 0:12], 35),
        ("rs1",        instr[12:17], 10),
        ("funct3",     instr[17:20],  7),
        ("rd",         instr[20:25], 17),
        ("opcode",     instr[25:32],  7),
    ]

def decode_s_type(instr):
    return [
        ("imm[11:5]",  instr[ 0: 7], 21),
        ("rs2",        instr[ 7:12], 14),
        ("rs1",        instr[12:17], 10),
        ("funct3",     instr[17:20],  7),
        ("imm[4:0]",   instr[20:25], 17),
        ("opcode",     instr[25:32],  7),
    ]

def decode_b_type(instr):
    return [
        ("imm[12]",    instr[    0],  8),
        ("imm[10:5]",  instr[ 1: 7], 13),
        ("rs2",        instr[ 7:12], 14),
        ("rs1",        instr[12:17], 10),
        ("funct3",     instr[17:20],  7),
        ("imm[4:1]",   instr[20:24],  9),
        ("imm[11]",    instr[   24],  8),
        ("opcode",     instr[25:32],  7),
    ]

def decode_u_type(instr):
    return [
        ("imm[31:12]", instr[ 0:20], 52),
        ("rd",         instr[20:25], 17),
        ("opcode",     instr[25:32],  7),
    ]

def decode_j_type(instr):
    return [
        ("imm[20]",    instr[    0],  8),
        ("imm[10:1]",  instr[ 1:11], 19),
        ("imm[11]",    instr[   11],  8),
        ("imm[19:12]", instr[12:20], 17),
        ("rd",         instr[20:25], 17),
        ("opcode",     instr[25:32],  7),
    ]

def decode_unknown(instr):
    return [
        ("unknown",    instr[ 0:25], 69),
        ("opcode",     instr[25:32],  7),
    ]

def decode(instr_bin):
    opcode = instr_bin[25:32]

    if opcode == "0110011":
        return "R", decode_r_type(instr_bin)

    elif opcode in ("0010011", "0000011"):
        return "I", decode_i_type(instr_bin)

    elif opcode == "0100011":
        return "S", decode_s_type(instr_bin)

    elif opcode == "1100011":
        return "B", decode_b_type(instr_bin)

    elif opcode in ("0110111", "0010111"):
        return "U", decode_u_type(instr_bin)

    elif opcode in ("1101111", "1100111"):
        return "J", decode_j_type(instr_bin)

    else:
        return "?", decode_unknown(instr_bin)

def print_line():
    print("-" * 139)

def main(asm_file):
    asm_file = pathlib.Path(asm_file)

    with tempfile.TemporaryDirectory() as tmp:
        obj = pathlib.Path(tmp) / "out.o"

        run(["riscv64-unknown-elf-as", "-march=rv32i", asm_file, "-o", obj])
        dump = run(["riscv64-unknown-elf-objdump", "-d", obj])

        print("type | assembly                                | hex        | 31      30           24    20      19        14     11       7       6     0")

        last_type = None
        for line in dump.splitlines():
            m = re.match(r"\s*[0-9a-f]+:\s+([0-9a-f]{8})\s+(.*)", line)
            if not m:
                continue

            hex_word = m.group(1)
            asm_raw = normalize_asm(m.group(2))

            mnemonic, operands = split_asm(asm_raw)
            asm_fmt = f"{mnemonic:<8} {operands:<31}"

            instr_bin = f"{int(hex_word, 16):032b}"
            itype, fields = decode(instr_bin)

            names  = "".join(f"{name:{spaces}}" for name, _, spaces in fields)
            values = "".join(f"{value:{spaces}}" for _, value, spaces in fields)

            if last_type != itype:
                print_line()
                print(f"{itype}    |{'':<40} | {'':<10} | {names}")
            last_type = itype
            print(f"     |{asm_fmt} | 0x{hex_word} | {values}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: decode.py arquivo.asm")
        sys.exit(1)

    main(sys.argv[1])
