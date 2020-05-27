all: main.exe

main.exe: copy.o
	gcc -m32 main.c -o main fpu.obj

copy.o:
	nasm -f win32 fpu.asm