####################################################################################################################################
# Anh Vu L Nguyen
# 
# A program that process string to remove all digit characters and return the output
####################################################################################################################################
	
	.data
message:	.asciiz 	"Please input a string with less than 50 words into the following box:"
buffer:	.space 	51
noInput:	.asciiz	"Nothing was entered.\n"
tooLong:	.asciiz	"The entered string exceed the maximum number of characters of 50.\n"
success:	.asciiz	"Not a digit\n"
successNot:	.asciiz	"A digit\n"
return:	.space	51

	.text
main:
	li 	$v0, 54
	la	$a0, message
	la	$a1, buffer		#buffer now has the input string
	li	$a2, 51		#the limit of word
	syscall
	
	#Check for status of input
	beq	$a1, -2, nothing
	beq	$a1, -3, nothing
	beq	$a1, -4, exceed
	
	#if the input string is good
	la	$s0, buffer	#pointer points to first word
	la	$s1, return
	jal	attempt

#----------------------------------------------------
# After the string is processed, dialog output is done down here 
#----------------------------------------------------
printOutput:
	# syscall so that output is in a dialog message box
	li	$v0, 55
	la	$a0, return
	li	$a1, 1
	syscall
	
fin:
	li	$v0, 10	#exit the program
	syscall
	
#----------------------------------------------------
# Dealing with error input down here
#----------------------------------------------------

nothing:	
	li	$v0, 55
	la	$a0, noInput
	li	$a1, 0
	syscall
	j	fin
	
exceed:	
	li	$v0, 55
	la	$a0, tooLong
	li	$a1, 0
	syscall
	j	fin

#----------------------------------------------------
# Actual procedure to process the string
#----------------------------------------------------	

attempt:
loopTop:
	lb	$t1, 0($s0)		#checking the character at this counter
	beqz	$t1, printOutput	#check to make sure it is not at the end of the char array
	
	
	#Checking if char is a digit
	li	$t0, 48	
	blt 	$t1, $t0, notdig	# if acsii char < '0' then it's not a digit
	li	$t0, 57
	blt	$t0, $t1, notdig	# if acsii char > '9' then it's not a digit
	
	# a digit
	addi	$s0, $s0, 1	#skip to next char
	j	loopTop
	
notdig:
	sb	$t1, ($s1)	#copy into the return space
	addi	$s0, $s0, 1	#skip to next char of input array
	addi	$s1, $s1, 1	#jump the next place in space 
	j	loopTop
	
