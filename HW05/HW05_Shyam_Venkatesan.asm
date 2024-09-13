# Author: Shyam Venkatesan
# Date: 3/26/2024
# Description: A program that takes a lower bound and upper bound input from a user, and prints out all the internal sums both recursively and iteratively.

# Includes simpler SysCalls file
.include "SysCalls.asm"

# Data section
.data
prompt1: .asciiz "Give me a number between 1 and 100 (0 to stop): " # Prompt for first number

# Prompts for second number
prompt2: .asciiz "Give me a second number between " 
prompt3: .asciiz " and 100 (0 to stop): "

# Messages for listing integer range that will be added
msg1:    .asciiz "Adding all integers from "
msg2:    .asciiz " to "

# Messages to show the iterative & recursive results (new line character used)
msg3:    .asciiz "\nITERATIVE: "
msg4:    .asciiz "\nRECURSIVE: "

# Text section
.text

# The main label is used for user input and calling the recursive/iterative functions, repeats unless user exits
main:

# Syscall to print out the prompt1 asciiz
li $v0, SysPrintString             
la $a0, prompt1
syscall
    
# Syscall to read in the user input integer for the lower bound
li $v0, SysReadInt             
syscall
move $t0, $v0 # Moves retrun value of v0 to the t0 register (holds lower bound)        
    
beq $t0, $zero, exit # Branch statement checks if t0 equals 0 (exit condition) and jumps to the exit label if true     
 
# Syscall to print out the prompt2 asciiz      
li $v0, SysPrintString        
la $a0, prompt2
syscall
 
# Syscall to print out the new low bound of numbers to choose (the chosen lower bound)            
li $v0, SysPrintInt
move $a0, $t0 # value of t0 moved to argument register, a0    
syscall

# Syscall to print out the prompt3 asciiz, the end of the second number prompt
li $v0, SysPrintString
la $a0, prompt3
syscall

# Syscall to read in the user input integer for the lower bound
li $v0, SysReadInt       
syscall
move $t1, $v0 # Moves retrun value of v0 to the t0 register (holds lower bound)          
    
beq $t1, $zero, exit # Branch statement checks if t1 equals 0 (exit condition) and jumps to the exit label if true        
    
bgt $t0, $t1, exit # Branch statement checks if t0 > t1 (improper input) and jumps to the exit label if true     

# Syscall to print out the msg1 asciiz
li $v0, SysPrintString          
la $a0, msg1
syscall

# Syscall to print out the lower bound          
li $v0, SysPrintInt
move $a0, $t0  # t0 is the lower bound, value moved to a0
syscall
    
# Syscall to print out the rest of the print message, msg2 asciiz
li $v0, SysPrintString         
la $a0, msg2
syscall

# Syscall to print out the upper bound
li $v0, SysPrintInt
move $a0, $t1 # t1 is the upper bound, value moved to a0       
syscall

# Syscall to print out the iterative case, msg3 asciiz    
li $v0, SysPrintString
la $a0, msg3
syscall
    
move $t3, $t0 #t3, the sum variable, is given the value of t0
move $t4, $t0 #t4, the counter variable, is given the value of t0
jal itr_sum # Jump and link to the itr_sum function
       
# Syscall to print out the recursive case, msg4 asciiz                  
li $v0, 4
la $a0, msg4
syscall

move $t3, $t1 #t3, the sum variable, is given the value of t0
move $t4, $t0 #t4, the counter variable, is given the value of t0     
jal rec_sum # Jump and link to the rec_sum function

# Syscall to print the new line character    
li $v0, SysPrintChar
li $a0, 10 # 10 is the value of the \n cbaracter
syscall

# Jumps back to the start of main for another iteration of the process        
j main         

# The itr_sum label for the iterative function        
itr_sum:
addi $t3, $t3, 1 # increment t3 (counter)
add $t4, $t4, $t3 # Add new value of t3 to t4 (sum variable), which represents the next sum within the range

# Syscall to print out the empty space character        
li $v0, SysPrintChar
li $a0, 32 # 32 is the value of the " " character
syscall

# Syscall to print out the current sum (t4)
li $v0, SysPrintInt
move $a0, $t4 # a0 (argument) given value of t4
syscall

# Loop condition checks if t3 (counter) less than t1 (upper bound), jumps back to the top of itr_sum as long as it evaluates to true        
blt $t3, $t1, itr_sum

# Jump register used to return to the calling location in main and continue the following instructions        
jr $ra

# The rec_sum label for the recursive function          
rec_sum:
addi $sp, $sp, -8 # Moves stack pointer down by 8 to make space for 2 variables on the stack
sw $ra, 0($sp) # Return address stored in the 0 position of stack pointer
sw $t3, 4($sp) # t3 (counter variable) stored in the 4 position offset from the stack pointer

# Condition that jumps to rec_helper as long as t3 (counter) is greater than t0 (lower bound) 
bgt $t3, $t0, rec_helper # Base case is that t3 = t0, ends recursion
   
addi $sp, $sp, 8 # Stack pointer returned to initial position

# Jump register back to the caller's address
jr $ra

# Helper for the recursive function that does the arithmetic operations and popping from stack        
rec_helper:
subi $t3, $t3, 1 # Decrements counter by 1
jal rec_sum # Calls rec_sum with the new t3 value
lw $t3, 4($sp) # Value of t3 popped from the stack (offset 4)
lw $ra, 0($sp) # Value of return address loaded from stack (offset 0)

addi $sp, $sp, 8 # Stack pointer returned to initial position
add $t4, $t3, $t4 # Value of t3 (counter) added to t4 (sum)

# Syscall to print out the empty space character    
li $v0, SysPrintChar
li $a0, 32 # 32 is the value of the " " character
syscall

# Syscall to print out the value of the sum    
li $v0, SysPrintInt
move $a0, $t4 # Value of t4 (sum) moved to argument, a0
syscall

# Jump register back to the return address   
jr $ra  

# Label for the exit syscall 
exit:
li $v0, SysExit # Syscall to exit the program            
syscall
