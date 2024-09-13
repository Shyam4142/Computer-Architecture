# Author: Shyam Venkatesan
# Date: 2/21/2024
# Description: A program that takes an array of numbers, -31 to 32, and randomizes the number's positions using a fisher-yates shuffle. The program acts as a bingo cage machine, printing the first 10 array values.

# Includes simpler SysCalls file
.include "SysCalls.asm"

# Data Segment
.data
# word array BingoArray stores all numbers -31 to 32, inclusive
BingoArray: .word -31, -30, -29, -28, -27, -26, -25, -24, -23, -22, -21, -20, -19, -18, -17, -16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32

# Message preceding the 10 bingo numbers, new line character at the end
Message: .asciiz "Let's Play Bingo! Press Enter to get the next Bingo call:\n"

# Instructions Segment
.text

# Loads the BingoArray address into t0
la $t0, BingoArray

# Loads immediate 63 into t1 (i)
li $t1, 63
    
# Prints the Message asciiz
li $v0, SysPrintString
la $a0, Message
syscall

# loop is the label to loop through the array and swap values    
loop:
# if i = 0, branch to exit1 
beqz $t1, exit1

# syscall for a random int within the range [0, i+1)
li $v0, SysRandIntRange
addi $a1, $t1, 1 # 1 added to i, because the right bound is exclusive
syscall 
    
move $a2, $a0 # a2 is given the random value (j)
move $a0, $t0 # a0 is given the address of BingoArray
move $a1, $t1 # a1 is given the value of i

# SWAP procedure is called, jumps and links
jal SWAP

# Decrements i by one
subi $t1, $t1, 1

# Calls the loop label again to loop back to the beginning
 j loop

# The exit branch label for loop
exit1: 
move $t1, $zero # Resets t1 to 0, to act as the new i
li $t2, 9 # Sets t2 to 9, to act as the upper bound of the print loop

# label for the printing loop
print:
# if i > 9, branch to exit2
bgt $t1, $t2, exit2

sll $t3, $t1, 2 # Calculates the offset by left logical shift of i by 2 (x4)
add $t3, $t3, $t0 # Adds base address to the offset of the index
lw $t4, 0($t3) # Loads word stored in memory location into t4

# Syscall to print the word stored in t4
li $v0, SysPrintInt
move $a0, $t4 # t4 is moved into a0, the parameter register
syscall

# Syscall to print a new line character 
li $v0, SysPrintChar
li $a0, 10 # 10 is the value of \n
syscall

# Increments i by one
addi $t1, $t1, 1

# Calls the print label again to loop back to the beginning
j print

# Exit branch label for the print loop
exit2:

# Instruction to exit from the MIPS program
li $v0, SysExit
syscall

# Label for the SWAP procedure
SWAP:
  
sll $t3, $a1, 2 # Calculates the offset by left logical shift of i by 2 (x4)
sll $t4, $a2, 2 # Calculates the offset by left logical shift of j by 2 (x4)

add $t3, $t3, $a0 # Adds base address to the offset i
add $t4, $t4, $a0 # Adds base address to the offset j

lw $t5, 0($t3)  # Loads word stored in array[i]'s memory location into t5
lw $t6, 0($t4)  # Loads word stored in array[j]'s memory location into t6

sw $t5, 0($t4) # Stores word originially in array[j] in array[i]
sw $t6, 0($t3) # Stores word originially in array[i] in array[j]

# Jump register back to the calling location
jr $ra
