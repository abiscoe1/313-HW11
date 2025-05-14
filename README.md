**Ashley Biscoe Homework #11**

**How to Run:**  
nasm -f elf32 -g -F dwarf -o hw11translate2Ascii.o hw11translate2Ascii.asm  
ld -m elf_i386 -o hw11translate2Ascii hw11translates2Ascii.o  
./hw11translate2Ascii  
*To translate a different set of bytes, they must be hardcoded in the .data section of the program.*    

**Program Output:**  
When run, the program will output the hex version of the bytes defined in the .data section of the program, followed by a blank new line. Every byte of data is translated individually from the input buffer and added to the output buffer along with spaces between each translated byte.
