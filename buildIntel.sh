#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 file1.asm [file2.asm ...]"
    exit 1
fi

for file in $*; do
    nasm -f elf $file
done

ld -m elf_i386 ${*%.asm}.o -o ${1%.asm}.exe