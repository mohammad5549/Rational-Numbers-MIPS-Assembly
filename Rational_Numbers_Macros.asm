#
#    Mohammad Iqbal
#    CSC 210
#    09/30/2024 Rational Number Arithmetic Using Macros
#

     .data
prompt_rational1:   .asciiz "Enter the first rational number (format: p1 *ENTER* q1): "
prompt_rational2:   .asciiz "Enter the second rational number (format: p2 *ENTER* q2): "
prompt_operation:   .asciiz "Choose the operation: (1) Add, (2) Subtract, (3) Multiply, (4) Divide: "
error_zero_den:     .asciiz "Error: denominator cannot be zero!\n"
result_msg:         .asciiz "Result: "
newline:            .asciiz "\n"

# Macro Definitions

	# Prints the string passed into the paramter %str
	.macro print_str (%str)
		li $v0, 4
		la $a0, %str
		syscall
	.end_macro

	# Uses the previously defined macro 'print_str' to print the newline string in the data segment
	.macro print_newline
		print_str (newline)
	.end_macro

	# Prints the value of the int stores in the register that is passed into the paramter %int
	.macro print_int (%int)
		li $v0, 1
		move $a0, %int
		syscall
	.end_macro

	# Uses previously defined macros to print in a rational number format the int values stored in the corresponding registers that are passed into the paramters %numerator and %denominator.
	.macro print_rational_num (%numerator, %denominator)
		print_int (%numerator)				# Print numerator (result of operation)
		print_newline					# Print newline
		print_int (%denominator)			# Print denominator (common denominator)
		print_newline					# Print newline
	.end_macro

	# Reads an int from the user
	.macro read_int
		li $v0, 5
		syscall
	.end_macro

	# Stores the value in the $v0 register to a specified register %reg
	.macro store_int (%reg)
		move %reg, $v0
	.end_macro

	# Terminates the program
	.macro done
		li $v0, 10
		syscall
	.end_macro


    .text
    .globl main
main:
    # First Rational Number (p1/q1)
    print_str (prompt_rational1)       # Print the prompt for the first rational number
    print_newline		       # Print newline
    
    read_int			       # Read p1 (numerator)
    store_int ($t0)		       # Store p1 in $t0

    read_int			       # Read q1 (denominator)
    store_int ($t1)		       # Store q1 in $t1

    # Check if q1 == 0
    beqz    $t1, denominator_error

    # Second Rational Number (p2/q2)
    print_str (prompt_rational2)       # Print the prompt for the second rational number
    print_newline		       # Print newline
    
    read_int			       # Read p2 (numerator)
    store_int ($t2)		       # Store p2 in $t2
    
    read_int			       # Read q2 (denominator)
    store_int ($t3)		       # Store q2 in $t3

    # Check if q2 == 0
    beqz    $t3, denominator_error

    # Operation Selection
    print_str (prompt_operation)       # Print the prompt for the operation selection
    print_newline		       # Print newline
    
    read_int			       # Read the operation choice
    store_int ($t4)		       # Store the choice in $t4

    # Perform the chosen operation
    print_str (result_msg)	       # Print the result message
    print_newline

    # Add: (p1/q1) + (p2/q2) => (p1*q2 + p2*q1) / (q1*q2)
    li      $t5, 1                     # Option 1: Addition
    beq     $t4, $t5, add_rationals

    # Subtract: (p1/q1) - (p2/q2) => (p1*q2 - p2*q1) / (q1*q2)
    li      $t5, 2                     # Option 2: Subtraction
    beq     $t4, $t5, subtract_rationals

    # Multiply: (p1/q1) * (p2/q2) => (p1*p2) / (q1*q2)
    li      $t5, 3                     # Option 3: Multiplication
    beq     $t4, $t5, multiply_rationals

    # Divide: (p1/q1) / (p2/q2) => (p1*q2) / (q1*p2)
    li      $t5, 4                     # Option 4: Division
    beq     $t4, $t5, divide_rationals

    # Exit Program
    done			       # Exit system call

add_rationals:
    mul     $t6, $t0, $t3              # p1 * q2
    mul     $t7, $t2, $t1              # p2 * q1
    add     $t8, $t6, $t7              # p1*q2 + p2*q1
    mul     $t9, $t1, $t3              # q1 * q2
    j       print_result

subtract_rationals:
    mul     $t6, $t0, $t3              # p1 * q2
    mul     $t7, $t2, $t1              # p2 * q1
    sub     $t8, $t6, $t7              # p1*q2 - p2*q1
    mul     $t9, $t1, $t3              # q1 * q2
    j       print_result

multiply_rationals:
    mul     $t8, $t0, $t2              # p1 * p2
    mul     $t9, $t1, $t3              # q1 * q2
    j       print_result

divide_rationals:
    mul     $t8, $t0, $t3              # p1 * q2
    mul     $t9, $t1, $t2              # q1 * p2
    j       print_result

denominator_error:
    print_str (error_zero_den)	       # Print error message
    j       main                       # Restart the program

print_result:
    print_rational_num ($t8, $t9)

    j       main                       # Restart the program
