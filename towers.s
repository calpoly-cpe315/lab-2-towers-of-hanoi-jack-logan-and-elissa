	.arch armv8-a
	.text

@ print function is complete, no modifications needed
    .global	print
print:
      stp    x29, x30, [sp, -16]! // Store FP, LR.
      add    x29, sp, 0           // set FP
      mov    x3, x0               // x3 = x0
      mov    x2, x1               // x2 = x1
      ldr    w0, startstring      // load start string0
      mov    x1, x3               // x1 = x3
      bl     printf          
      ldp    x29, x30, [sp], 16   // Caller Teardown
      ret

startstring:
	.word	string0

    .global	towers
towers:
   /* Callee setup ???? */
   sub sp, sp, #8 // for return value (above the return address x30)
   stp x29, x30, [sp, -16]!  // Store FP, LR.
   mov x29, sp    /* same as add x29, sp, 0 */


   /* Save callee-saved registers to stack */
   sub sp, sp, #40         /* reserve 32 bytes for 5 callee-save registers */
   add sp, sp, #40         /* change stack pointer to bottom of the 5 callee-save registers */

   str x19, [x29, #-8]     /* preva = numDiscs */ 
   str x20, [x29, #-16]    /* prevb = start */
   str x21, [x29, #-24]    /* prevc = goal */
   str x22, [x29, #-32]    /* local variable d = temp = peg */
   str x23, [x29, #-40]    /* local variable e = steps */
   

   /* Save a copy of all 3 incoming parameters to callee-saved registers */
   ldr x21, [x29, #24]     /* c = goal */
   ldr x20, [x29, #32]     /* b = start */
   ldr x19, [x29, #40]     /* a = numDiscs */

if:
   /* Compare numDisks with 2 or (numDisks - 2)*/
   CMP x19, #-2
   /* Check if less than, else branch to else */
   B.LT else
   
   /* set print function's start to incoming start */
                                                              /* parameters for print correct ??? */
   mov x0, x20 // ASSUMING X0 IS START PARAMETER FOR PRINT
   /* set print function's end to goal */
   mov x1, x21 // ASSUMING X1 IS END PARAMEETER FOR PRINT

   /* call print function */
   bl print

   /* Set return register to 1 */
   mov x0 #1
   str x0, [x29, 16]       /* location of return value (above frame pointer) in respect to frame pointer */

   /* branch to endif */
   br endif

else:
   /* Use a callee-saved variable for temp and set it to 6 */
   mov x22, #6
   /* Subract start from temp and store to itself */
   sub x22, x22, x20
   /* Subtract goal from temp and store to itself (temp = 6 - start - goal)*/
   sub x22, x22, x21


   /* subtract 1 from original numDisks and store it to numDisks parameter */
   sub x19, x19, #1

   // I think this is start of caller setup
   str x19, [sp, #-8]!     // push numDisks parameter
   str x20, [sp, *-8]!     // push start parameter (unchanged)
   /* Set end parameter as temp */
   str x22, [sp, #-8]!     // push temp=peg=goal (in this case peg is new goal) parameter


   /* Call towers function */    //start of recursive call to towers
   bl towers
   /* Save result to callee-saved register for total steps */
                                                                        //// NEED TO DO
   /* Set numDiscs parameter to 1 */
   /* Set start parameter to original start */
   /* Set goal parameter to original goal */
   /* Call towers function */
   /* Add result to total steps so far */
   
   /* Set numDisks parameter to original numDisks - 1 */
   /* set start parameter to temp */
   /* set goal parameter to original goal */
   /* Call towers function */
   /* Add result to total steps so far and save it to return register */
                     //
endif:
   /* Restore Registers */
   ldr x19, [x29, #-8]
   ldr x20, [x29, #-16]
   ldr x21, [x29, #-24]
   ldr x22, [x29, #-32]
   ldr x23, [x29, #-40]
   /* Return from towers function */
                              //

@ Function main is complete, no modifications needed
    .global	main
main:
      stp    x29, x30, [sp, -32]!
      add    x29, sp, 0
      ldr    w0, printdata 
      bl     printf
      ldr    w0, printdata + 4
      add    x1, x29, 28
      bl     scanf
      ldr    w0, [x29, 28] /* numDisks */
      mov    x1, #1 /* Start */
      mov    x2, #3 /* Goal */
      bl     towers
      mov    w4, w0
      ldr    w0, printdata + 8
      ldr    w1, [x29, 28]
      mov    w2, #1
      mov    w3, #3
      bl     printf
      mov    x0, #0
      ldp    x29, x30, [sp], 16
      ret
end:

printdata:
	.word	string1
	.word	string2
	.word	string3

string0:
	.asciz	"Move from peg %d to peg %d\n"
string1:
	.asciz	"Enter number of discs to be moved: "
string2:
	.asciz	"%d"
	.space	1
string3:
	.ascii	"\n%d discs moved from peg %d to peg %d in %d steps."
	.ascii	"\012\000"
