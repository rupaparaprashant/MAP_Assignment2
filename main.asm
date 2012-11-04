;Assignment 2 
;Question 1
;EE 675 Group 10
;Authors : Prashant Rupapara & Shreyas Shyamsunder

	.def MAIN		; Makes MAIN global

	.data

array1:	.word	array1
		.word	2
		.word	1
		.word	2
		.float	3.0
		.float	2.0
		.float	3.0
		.float	4.0
		.float	5.0
		.float	0.0
array2:	.word	array2
		.word 	2
		.word 	1
		.word 	2
		.float	2.0
		.float	-6.0e+3
		.float	6.28
		.float	3.2
		.float	5.4
		.float	1.0
array3  .word	array3
		.word	2
		.word	2
		.word	3
		.float	2.0
		.float	7.0
		.float	8.0
		.float	7.0
		.float	6.0
		.float	5.0
		.float	4.0
		.float	3.0
		.float	2.0
		.float	1.0
		.float	0.0
		.float	1.0


array4:	.word	array4
		.word	2
		.word 	1
		.word 	2
		.word	0
		.float	0.0
		.float	0.0
		.float	0.0
		.float	0.0
		.float	0.0
		.float	0.0
		.float	0.0
		.float	0.0
		.float	0.0
		.float	0.0
		.float	0.0

	.text

MAIN:
	ldp	@array1
	ldi	@array3, AR0
	ldi @array3, AR1
	ldi @array4, AR2
	
	;ldi 1,R0
	;ldi 1,R1
	;call getnum_2
	;call getnum_1
	;ldf 9.0,R3
	;call setnum_1
	
	;call mmult
	;call madd
	;call msub
	;call mneg
	call mtrn
	bg:	br	bg

	.end
	