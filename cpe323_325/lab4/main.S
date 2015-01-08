#include "msp430.h"

	NAME	main
	PUBLIC	main
	EXTERN	suma_rp
	EXTERN	suma_sp
	
	RSEG	CSTACK
	RSEG	CODE
	
main:		MOV		#SFE(CSTACK), SP
		MOV.W	#WDTPW+WDTHOLD, &WDTCTL
		BIS.B	#0XFF,&P1DIR
		BIS.B	#0XFF,&P2DIR
		
		PUSH	#var1
		PUSH	#var2
		CALL	#suma_sp
							; R5 is now the ans
		ADD		#4, SP
		
		
		
		MOV		#var3, R6
		MOV		#var4, R7
		CALL	#suma_rp
							; R4 is now the ans
		
		CMP		R5, R4
		JN		lneg
		MOV.B	R4, P1OUT
		SWPB	R4
		MOV.B	R4, P2OUT


lneg	MOV.B	R5, P1OUT
		SWPB	R5
		MOV.B	R5, P2OUT


		JMP		$
		
var1	DC8		12
var2	DC8		12
var3	DC8		6
var4	DC8		6

		END



