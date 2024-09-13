# Author: Shyam Venkatesan
# Date: 3/26/2024
# Description: A program that takes an odd integer between 0 and 100, generates a magic square for it, and displays the square.

# Includes simpler SysCalls file
.include "SysCalls.asm"

# Data Section
.data
prompt: .asciiz "Give me an odd nubmer between 0 and 100: " # Prompt for integer input
even_error: .asciiz "Your input was even, must be odd" # Error message before exiting for even input
negative_error: .asciiz "Your input was negative, must be positive" # Error message before exiting for negative input

# Text Section
.text

# Main label used for user input, error checking, and allocating memory
main:

# Syscall to print out the prompt asciiz
li $v0, SysPrintString
la $a0, prompt
syscall

# Syscall to read in user input for the size integer
li $v0, SysReadInt
syscall

# Size value moved to $s0 register
move $s0, $v0

li $t0, 2 # $t0 stores divisor of 2
div $s0, $t0 # Divides size by 2
mfhi $t1 # Remainder transferred to $t1

# If remainder is 0, the size is even, so the instruction branches to the even_exit label
beq $t1, $zero, even_exit 

# If size is less than 0, it is negative, so the instruction branches to the negative_exit label
blt $s0, $zero, negative_exit 

# SysAlloc syscall used to allocate memory for the 2D array
li $v0, SysAlloc
mul $t0, $s0, $s0 # Multiplies size by itself to form a NxN array size
move $s1, $t0 # Stores NxN in $s1
sll $a0, $t0, 2 # Logical shift left used to multiply NxN by 4, to make it word aligned
syscall # Calls SysAlloc with given memory size
move $s2, $v0 # Moves memory location of the 2D array to $s2

li $t0, 2 # $t0 stores divisor of 2
div $t1, $s0, $t0 # Divides size by 2, and stores it in $t1 (x)
subi $t2, $s0, 1  # Subtracts 1 from size, and stores it in $t2 (y)
li $t3, 1 # # Sets $t3 to 1 (i)

# Label for iteratively generating the square
generate_square:
mul $t0, $t1, $s0 # Multiplies x by size to get the row
add $t0, $t0, $t2 # Adds y to the previous result to get row & column
sll $t0, $t0, 2 # Shift logical left by 2 to word align previous result
add $t0, $t0, $s2 # Adds offset ($t0) to memory location ($s2)
sw $t3, 0($t0) # Stores value of i inside the memory location (x, y)

div $t3, $s0 # Divides i by size
mfhi $t4 # Remainder stored in $t4
beqz $t4, move_left # Branches to move_left if $t4 is equal to zero (multiple of N)

# Moves towards the top-right
subi $t1, $t1, 1 # Moves 1 down in x
addi $t2, $t2, 1 # Moves 1 right in y

# Jumps to bounds_fix label
j bounds_fix

# Case if i is a multiple of N
move_left:
subi $t2, $t2, 1 # Moves 1 left in y

# Label that fixes x and y to avoid out of bounds, checks for loop continuation
bounds_fix:
# Stores (N + x) % N in x
add $t1, $t1, $s0 # Adds N to x
div $t1, $s0 # Divdes x by N
mfhi $t1 # Stores remainder in $t1 (x)

# Stores (N + y) % N in y 
add $t2, $t2, $s0 # Adds N to y
div $t2, $s0 # Divides y by N
mfhi $t2 # Stores remainder in $t2 (y)

# Increments i by 1
addi $t3, $t3, 1

# If i <= NxN, loop back to generate_square
ble $t3, $s1, generate_square

# Sets $t0 (i) for print_row to 0
li $t0, 0

# Label for printing each row of the square
print_row:
li $t1, 0 # Sets $t1 (j) for print_col to 0
jal print_col # Jumps and links to print_col
addi $t0, $t0, 1 # After print_col completes, increments i by 1
bge $t0, $s0, exit # Checks if i >= N, branches to exit if true

# Syscall to print a new line character
li $v0, SysPrintChar
li $a0, 10 # Numerical value for new line character
syscall

# Jumps back to print_row to continue the loop
j print_row

# Label for printing each column of the square
print_col:
mul $t2, $t0, $s0 # Multiplies i by N to find row
add $t2, $t2, $t1 # Adds j to the previous value to find row, column
sll $t2, $t2, 2 # Shifts logicially left by 2 to word align the previous value
add $t2, $t2, $s2 # Adds memory location to offset 
lw $t3, 0($t2) # Loads word from the calculated memory location into $t3

# Syscall to print the value at i, j in the 2D array
li $v0, SysPrintInt
move $a0, $t3 # Word that was loaded in from memory
syscall

# Syscall to print an empty space character
li $v0, SysPrintChar
li $a0, 32 # Numerical value for empty space character
syscall

# Increments j by 1
addi $t1, $t1, 1

# Checks if j < N, loops back to print_col if true
blt $t1, $s0, print_col

# Jumps register back to return address to continue print_row loop
jr $ra

# Exit label for even error case
even_exit:
# Syscall to print out even_error asciiz
li $v0, SysPrintString
la $a0, even_error
syscall

# Syscall to exit from the program
li $v0, SysExitValue
syscall

# Exit label for even error case
negative_exit:
# Syscall to print out negative_error asciiz
li $v0, SysPrintString
la $a0, negative_error
syscall

# Syscall to exit from the program
li $v0, SysExitValue
syscall

# Exit label for normal exit case
exit:
# Syscall to exit from the program
li $v0, SysExitValue
syscall

