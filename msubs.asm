;Assignment 2 
;Question 1
;EE 675 Group 10
;Authors : Prashant Rupapara & Shreyas Shyamsunder


	.global madd
	.global msub
	.global mneg
	.global mtrn
	.global mmult
	
	
	.data

error_2	.word	0

	
	.text

; It has been assumed that user push required data before calling function because it 
; Library function can not know what registers are being used by user and pushing all the
; register on stacks is lot of unnecessary overhead.
	

;=========================================================================================

; Function to multiply two matrixes.
mmult:
	ldi 0,R0
	sti R0,error_2  ; makes error_2 '0' before doing job.  
	
	ldi *+AR0(3),R0 ; column of matrix A
	ldi *+AR1(2),R1 ; row of matrix B
	cmpi3 R0,R1     ; check for dimensions
	bne error_2_0x01
	
	ldi *+AR0(2),R2 ; row of matrix A
	ldi *+AR1(3),R3 ; column of matrix B
	sti R2,*+AR2(2) ; row of matrix C
	sti R3,*+AR2(3) ; column of matrix C
	
	addi 1,R1  ; Converts row & column number to '1' to 'x' from previous '0' to 'x'  
	addi 1,R2
	addi 1,R3

	
	; for reference registers are given names via comments
	; C(i,k) = sum{A(i,j)*B(j,k)} 
	; i upto row of matrix A
	; j upto column of matrix A/row of matrix B
	; k upto column of matrix B
	
	
	ldi 0,R4 ; i	
mult_loop_1:

	ldi 0,R6 ; k

mult_loop_2: 
	ldi 0,R5 ; j
	ldf 0,R0 ; accumulator

mult_loop_3:	
	
	pushf R0 
	push R1
	ldi R4,R0 
	ldi R5,R1
	call get_val_for_mult ; returns value in R0 at a specified row,column by specifying 
	ldf R0,R7			  ;	it's row in R0 and column in R1 
	
	push AR0
	ldi AR1,AR0
	ldi R5,R0
	ldi R6,R1
	call get_val_for_mult
	
	mpyf R0,R7  ; A(i,j)*B(j,k)
	
	bv error_2_0x04			; check for floating point overflow
	buf error_2_0x04		; check for floating point underflow
	
	pop AR0
	pop R1
	popf R0              
	
	addf R7,R0  ; sum = A(i,j)*B(j,k)
	
	bv error_2_0x04			; check for floating point overflow
	buf error_2_0x04		; check for floating point underflow
	
	addi 1,R5   ; incrementing loop_3's counter
	cmpi R5,R1  ; comparing for loop_3's remaning iteration 
	bne mult_loop_3
	
	push AR0
	push R3
	
	ldf R0,R3   ; C(i,k) = sum{A(i,j)*B(j,k)}
	ldi R4,R0
	ldi R6,R7
	ldi AR2,AR0
	call set_val_for_mult ; stores value in array at a specified row,column in memory 
						  ; by specifying it's row in R0 and column in R1 
						  ; value passed by R3
	
	pop R3
	pop AR0
	
	addi 1,R6  ; incrementing loop_2's counter
	cmpi R6,R3 ; comparing for loop_2's remaning iteration 
	bne mult_loop_2
	
	addi 1,R4  ; incrementing loop_1's counter
	cmpi R4,R2 ; comparing for loop_1's remaning iteration 
	bne mult_loop_1
	retsu
	
error_2_0x01:  ; error handling for multiplication 
	ldi 1,R4
	sti R4,@error_2
	retsu

; get value function used in multiplication function
get_val_for_mult:	
	push R4
	ldi R0,R4
	mpyi *+AR0(3),R4
	addi R1,R4
	addi 4,R4			; ans = (j*R0)+R1+4+R0  where j is *+AR0(3)
	addi R4,R0
	ldi R0,IR0
	ldf *+AR0(IR0),R0;
	pop R4
	retsu

; set value function used in multiplication function
set_val_for_mult:	
	push R4
	ldi R0,R4
	mpyi *+AR0(3),R4
	addi R7,R4			; ans = (j*R0)+R7+4+R0 where j is *+AR0(3)
	addi 4,R4
	addi R4,R0
	ldi R0,IR0
	stf R3,*+AR0(IR0)
	pop R4
	retsu

;=========================================================================================

; Function to add two matrixes.
madd:
	ldi 0,R1
	sti R1,error_2 ; makes error_2 '0' before doing job.  
	
	ldi *+AR0(2),R2 
	ldi *+AR1(2),R3
	cmpi3 R2,R3			; check for dimensions
	bne error_2_0x02
	ldi *+AR0(3),R2
	ldi *+AR1(3),R3
	cmpi3 R2,R3			
	bne error_2_0x02
	
	ldi *+AR0(2),IR0	; row of matrix A
	ldi *+AR0(3),IR1	; column of matrix A
	addi 1,IR0
	addi 1,IR1
	mpyi3 IR0,IR1,R1 	; R1 is loop count
	ldi 3,R3
	addi3 R3,R1,IR0 	; index to array

add_loop:
	
	addf3 *+AR0(IR0),*+AR1(IR0),R2  ; C(i) = A(i) + B(i)
	
	bv error_2_0x04			; check for floating point overflow
	buf error_2_0x04		; check for floating point underflow
	
	stf R2,*+AR2(IR0) ; writing result back to matrix C
	
	subi 1,IR0
	subi 1,R1		; loop iteration management
	bne add_loop
	retsu
	
error_2_0x02:
	ldi 2,R4		; error handling for addition 
	sti R4,@error_2
	retsu
	
;=========================================================================================

; Function to subtract two matrixes.
msub:
	ldi 0,R1
	sti R1,error_2 ; makes error_2 '0' before doing job.  
	
	ldi *+AR0(2),R2
	ldi *+AR1(2),R3	
	cmpi3 R2,R3			; check for dimensions
	bne error_2_0x03
	ldi *+AR0(3),R2
	ldi *+AR1(3),R3
	cmpi3 R2,R3
	bne error_2_0x03
	
	ldi *+AR0(2),IR0   ; row of matrix A
	ldi *+AR0(3),IR1   ; column of matrix A
	addi 1,IR0
	addi 1,IR1
	mpyi3 IR0,IR1,R1 ; R1 has loop count
	ldi 3,R3
	addi3 R3,R1,IR0 ;index to array

sub_loop:

	subf3 *+AR1(IR0),*+AR0(IR0),R2  ; C(i) = A(i) - B(i)

	bv error_2_0x04			; check for floating point overflow
	buf error_2_0x04		; check for floating point underflow

	stf R2,*+AR2(IR0) ; writing result back to matrix C
	
	subi 1,IR0
	subi 1,R1		  ; loop iteration management
	bne sub_loop
	retsu
	
error_2_0x03:
	ldi 3,R4		; error handling for subtraction 
	sti R4,@error_2
	retsu	
	
error_2_0x04:		
	ldi 4,R4		; common error handling floating point underflow and overflow for  
	sti R4,@error_2 ; functions of multiplication, addition and subtraction
	retsu


;=========================================================================================

;Function to negate a matrix.
mneg:
	ldi *+AR0(2),IR0	; row of matrix A
	ldi *+AR0(3),IR1	; column matrix A
	addi 1,IR0
	addi 1,IR1
	mpyi3 IR0,IR1,R1 ; R1 is loop count
	ldi 3,R2
	addi3 R2,R1,IR0 ; index to array

neg_loop:

	negf *+AR0(IR0),R2   ; C(i) = - A(i)
	stf R2,*+AR2(IR0)	 ; writing result back to matrix C

	subi 1,IR0
	subi 1,R1  ; loop iteration management
	bne neg_loop
	retsu
	
;=========================================================================================

;Function to transpose a matrix.
mtrn:
	ldi *+AR0(2),R4 ; row of matrix A
	ldi *+AR0(3),R5 ; column of matrix A
	sti R5,*+AR2(2)
	sti R4,*+AR2(3)
	addi 1,R4
	addi 1,R5
	
	;Algorithm explained in Report
	
	ldi 4,IR0

	ldi 0,R1	
trn_loop_1:	
	ldi 0,R2
	ldi R1,IR1
	addi 4,IR1

trn_loop_2:	
	ldf *+AR0(IR1),R3  ; Transpose action takes place here
	stf R3,*+AR2(IR0)
	
	addi3 R1,R5,IR1
	addi 4,IR1
	
	ldi 3,R6
	mpyi R2,R6
	addi R6,IR1
	
	addi 1,IR0
	addi 1,R2
	
	cmpi R4,R2		; incrementing loop_2's counter
	bne trn_loop_2	; comparing for loop_1's remaning iteration 
	
	addi 1,R1		; incrementing loop_1's counter
	cmpi R5, R1  	; comparing for loop_1's remaning iteration 
	bne trn_loop_1
	retsu

;=========================================================================================

	
.end

	
	