;; Original author: James Edmondson
;; Date: 4/18/2005
;; Modified by Joshua L. Phillips 11/06/2014 
;; Purpose: multiply two 32 bit numbers without shifts

; Jump over the data section

JUMP _init

;; Data segment

x1:	05 ; 5 in hexidecimal
x2:	03 ; 3 in hexidecimal
result:	80000000 ; eventually holds final product

;; Text segment

;; check that x1 is bigger than x2
;; if not, we'll need to swap x1 and x2
;; result is set to 80000000 to check the subtraction
;; value of x1 - x2.  Do not change!

_init:	
	LDAC x1
	MVAC
	CLAC
	OR

;; if x1 is a zero, just print out zero
	JMPZ _clear
	LDAC x2
	MVAC
	CLAC
	OR

;; if x2 is a zero, just print out zero

	JMPZ _clear
	LDAC x1
	SUB
	MVAC
	LDAC result
	AND
  
;; if the subtraction had the high bit cleared,
;; go ahead and jump to the start of the mul code

	JMPZ _multiply
  
;; else swap x1 and x2
  
	LDAC x2
	MVAC
	LDAC x1
	STAC x2
	MOVR
	STAC x1
  
;; begin mul function
  
_multiply:

	LDAC x1
	MVAC
	STAC result
	LDAC x2
  
;; because there is no decrement instruction, negate
;; x2 (the counter) and increment.  This accomplishes
;; a decrementing counter if we check for zero.
  
	NOT
	INC
	STAC x2
  
_loop:	

	INC
	JMPZ _print
	STAC x2
	LDAC result
	ADD
	STAC result
	LDAC x2
	JUMP _loop
  
;; if the program is here, then the inputs (x1 or x2) were zero
  
_clear:	

	STAC result
  
_print:	

	LDAC result
	OUT
  
;; End
	HALT
