;Assignment 2 
;Question 1
;EE 675 Group 10
;Authors : Prashant Rupapara & Shreyas Shyamsunder


	.global	getnum_2
	.global setnum_2
	.global getnum_1
	.global setnum_1
	
	.data

error_1	.word	0
	
	.text

; It has been assumed that user push required data before calling function because it 
; Library function can not know what registers are being used by user and pushing all the
; register on stacks is lot of unnecessary overhead.

	
;=========================================================================================


getnum_2:			; ans = (j*R0)+R1+4+R0 where j is *+AR0(3) ldi 0,R2
	
	ldi 0,R2
	sti R2,error_1   ; makes error_1 '0' before doing job. 
	
	cmpi *+AR0(2),R0 
	bp error_1_bit0    ; check for dimensions
	cmpi *+AR0(3),R1 
	bp error_1_bit0
	
	ldi R0,R4
	mpyi *+AR0(3),R4
	addi R1,R4
	addi 4,R4
	addi R4,R0
	ldi R0,IR0
	ldf *+AR0(IR0),R0
	retsu
		
error_1_bit0:
	ldi 1,R4		; error handling for getnum_2
	sti R4,@error_1
	retsu

;=========================================================================================
	
; Assumed that atleast one of the values of max i and j is zero.
; It was not mentioned in the question to tackle this issue.

getnum_1:  
	ldi 0,R2
	sti R2,error_1  ; makes error_1 '0' before doing job. 
	
	cmpi *+AR0(2),R0 
	bp error_1_bit1			; check for dimensions
	cmpi *+AR0(3),R1 
	bp error_1_bit1
	
	addi 4,R0
	ldi R0,IR0
	ldf *+AR0(IR0),R0 ;ans = R0+4
	retsu

error_1_bit1:
	ldi 2,R4		; error handling for getnum_1
	sti R4,@error_1
    retsu

;=========================================================================================


setnum_2:	;ans = (j*R0)+R1+4+R0
	ldi 0,R2
	sti R2,error_1   ; makes error_1 '0' before doing job. 
	
	cmpi *+AR0(2),R0 
	bp error_1_bit2
	cmpi *+AR0(3),R1 		; check for dimensions
	bp error_1_bit2
	
	ldi R0,R4
	mpyi *+AR0(3),R4
	addi R1,R4
	addi 4,R4
	addi R4,R0
	ldi R0,IR0
	stf R3,*+AR0(IR0)
	;ldf *+AR0(IR0),R5
	retsu
		
error_1_bit2:
	ldi 4,R4			; error handling for setnum_2
	sti R4,@error_1
	retsu
	
;=========================================================================================

;Assumed that atleast one of the values of max i and j is zero. 

setnum_1:  
	ldi 0,R2
	sti R2,error_1   ; makes error_1 '0' before doing job. 
	
	cmpi *+AR0(2),R0 
	bp error_1_bit3
	cmpi *+AR0(3),R1 		; check for dimensions
	bp error_1_bit3
	
	addi 4,R0
	ldi R0,IR0
	stf R3,*+AR0(IR0) ;ans = R0+4
	ldf *+AR0(IR0),R5
	and R4,R2
	retsz
error_1_bit3:
	ldi 8,R4			; error handling for setnum_1
	sti R4,@error_1
    retsu
	                          
.end
	
;=========================================================================================
	
	
	


