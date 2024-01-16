#!/bin/bash 

#++ Compile a assembly code (.*.asm|.*.s), using nasm and ld, the file is given as a parameter 

#++ Verify if a parameter was given

if [[ $# -ne 1 ]] 
then 
	echo "ERROR: use $0 <file>" >&2  
	exit 1 
fi 
#++ Verify if file.asm exists in the current dir 

if [[ ! -e ${1}.asm ]] 
then 
	echo "ERROR: file ${1}.asm do not exists" >&2 
	exit 2 
fi

nasm -g -f elf64 ${1}.asm 
ld -o $1 ${1}.o 

exit 0 
