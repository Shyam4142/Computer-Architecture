# Author: Shyam Venkatesan
# Date: 1/26/2024
# Description: A program where the user enters their name and 3 integers 1-100, and recieves result messages with the 3 final calculations and confirmation of the user inputs.

# Includes simpler SysCalls file
.include "SysCalls.asm"

# Data Segment
.data

# 3 variables f, g, and h to hold the user input integers 1-100, initialized to -
f: .word 0
g: .word 0
h: .word 0

# Outputs of the 3 calculations, initialized to 0
op1: .word 0
op2: .word 0
op3: .word 0

# Space for the user's name string
name: .space 256

# Prompts for name and input numbers
namePrompt: .asciiz "Enter your name: "
intPrompt: .asciiz "Enter a number from 1-100: "

# Output messages preceding the name, entered values, and resulting values
helloMsg: .asciiz "\nHello " # \n used for new line character
thanksMsg: .asciiz "Thank you for entering "
resultsMsg: .asciiz "\nI calculated your results to be " # \n used for new line character

# Instructions Segment
.text

# Prints the namePrompt asciiz
li $v0, SysPrintString 
la $a0, namePrompt 
syscall

# Reads the name entry into the name buffer, with 256 bit space
li $v0, SysReadString
la $a0, name # Buffer variable for syscall is name
la $a1, 256 # Buffer set to 256 bit
syscall

# Print the intPrompt asciiz
li $v0, SysPrintString
la $a0, intPrompt 
syscall

# Reads in the number entry into word f
li $v0, SysReadInt
syscall
sw $v0, f

# Print the intPrompt asciiz
li $v0, SysPrintString
la $a0, intPrompt
syscall

# Reads in the number entry into word g
li $v0, SysReadInt
syscall
sw $v0, g

# Print the intPrompt asciiz
li $v0, SysPrintString
la $a0, intPrompt
syscall

# Reads in the number entry into word h
li $v0, SysReadInt
syscall
sw $v0, h

# Loads f, g, and h values from variables into the t0, t1, and t2 buffers
lw $t0, f
lw $t1, g
lw $t2, h

# Calculation for 3f - g + 2, stored in word op1
add $t3, $t0, $t0 # f + f stored in t3
add $t3, $t3, $t0 # f + f + f stored in t3
sub $t3, $t3, $t1 # f + f + f - g stored in t3
addi $t3, $t3, 2 # f + f + f - g + 2 stored in t3
sw $t3, op1 # value from t3 switched to op1

# Calculation for h + (f - 3) + 2g, stored in word op2
add $t3, $t2, $t0 # h + f stored in t3
subi $t3, $t3, 3 # h + f - 3 stored in t3
add $t3, $t3, $t1 # h + f - 3 + g stored in t3
add $t3, $t3, $t1 # h + f - 3 + g + g stored in t3
sw $t3, op2 # value from t3 switched to op2

# Calculation for (f + 6) - (4 - h) + (g + 15), stored in word op3
addi $t3, $t0, 6 # f + 6 stored in t3
subi $t3, $t3, 4 # f + 6 - 4 stored in t3
add $t3, $t3, $t2 # f + 6 - 4 + h stored in t3
add $t3, $t3, $t1 # f + 6 -4 + h + g stored in t3
addi $t3, $t3, 15 # f + 6 - 4 + h + g + 15 stored in t3
sw $t3, op3 # value from t3 switched to op3

# Print the helloMsg asciiz
li $v0, SysPrintString
la $a0, helloMsg
syscall

# Print the user entered name 
li $v0, SysPrintString
la $a0, name
syscall

# Print the thanksMsg asciiz
li $v0, SysPrintString
la $a0, thanksMsg
syscall

# Print the first user entered number (word f)
li $v0, SysPrintInt
lw $a0, f
syscall

# Prints an empty space character
li $v0, SysPrintChar
la $a0, 32 # 32 is the integer value of an empty space character
syscall

# Print the second user entered number (word g)
li $v0, SysPrintInt
lw $a0, g
syscall

# Prints an empty space character
li $v0, SysPrintChar
la $a0, 32
syscall

# Print the third user entered number (word h)
li $v0, SysPrintInt
lw $a0, h
syscall

# Print the resultsMsg asciiz
li $v0, SysPrintString
la $a0, resultsMsg
syscall

# Print the first result value (word op1)
li $v0, SysPrintInt
lw $a0, op1
syscall

# Prints an empty space character
li $v0, SysPrintChar
la $a0, 32
syscall

# Print the second result value (word op2)
li $v0, SysPrintInt
lw $a0, op2
syscall

# Prints an empty space character
li $v0, SysPrintChar
la $a0, 32
syscall

# Print the third result value (word op3)
li $v0, SysPrintInt
lw $a0, op3
syscall

# Instuction to exit the MIPS program
li $v0, SysExitValue
syscall

# Test Values: f = 3, g = 7, h = 5
# Expected Results: ans1 = 4, ans2 = 19, ans3 = 32 






