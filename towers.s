	.arch armv8-a
	.text

// print function is complete, no modifications needed
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
   /* Save callee-saved registers to stack */
   stp x29, x30, [sp, -64]!   // Store FP, LR, move SP, reserve 6 registers space
   mov x29, sp                // Make FP = new SP
   stp x19, x20, [sp, 16]     //x19 = numDisks, x20 = start
   stp x21, x22, [sp, 32]     //x21 = goal, x22 = peg
   stp x23, x24, [sp, 48]     //x23 = steps, x24 = unused

   /* Save a copy of all 3 incoming parameters to callee-saved registers */
   mov x19, x0 //numDisks
   mov x20, x1 //start
   mov x21, x2 //goal

if:
   /* Compare numDisks with 2 or (numDisks - 2)*/
   cmp x19, #2
   /* Check if less than, else branch to else */
   b.ge else
   /* set print function’s start to incoming start */
   mov x0, x20 //start
   /* set print function’s end to goal */
   mov x1, x21 //goal
   /* call print function */
   bl print
   /* Set return register to 1 */
   mov x0, #1   //return 1
   /* branch to endif */
   b endif
else:
   /* Use a callee-saved variable for temp and set it to 6 */
   mov x22, #6
   /* Subract start from temp and store to itself */
   sub x22, x22, x20
   /* Subtract goal from temp and store to itself (temp = 6 - start - goal)*/
   sub x22, x22, x21


   /* subtract 1 from original numDisks and store it to numDisks parameter */
   //numdisks -1, start, peg
   sub x0, x19, #1   //make numDisks = numDisks -1 
   mov x1, x20    //make start = start
         /* Set end parameter as temp */
   mov x2, x22    //make end = peg
   /* Call towers function */
   bl towers
   mov x23, x0    //steps = answer

   //numdisks = 1, start, end
      /* Set numDiscs parameter to 1 */
   mov x0, #1     //make numDisks = 1
   mov x1, x20    //make start = start
   mov x2, x21    //make end = end
   bl towers
   /* Add result to total steps so far */
   add x23, x23, x0    //steps += answer

   //numdisks -1, peg, end
   /* Set numDisks parameter to original numDisks - 1 */
   sub x0, x19, #1   //make numDisks = numDisks -1 
   /* set start parameter to temp */
   mov x1, x22    //make start = peg
   /* set goal parameter to original goal */
   mov x2, x21    //make end = end
   /* Call towers function */
   bl towers
   /* Add result to total steps so far and save it to return register */
   add x23, x23, x0    //steps += answer
   mov x0, x23


   /* Call towers function */    //start of recursive call to towers
   //bl towers
   /* Save result to callee-saved register for total steps */
                                                                        //// NEED TO DO



   /* Set start parameter to original start */


   /* Set goal parameter to original goal */


   




endif:
   /* Restore Registers */
   ldp   x19, x20, [sp, 16]
   ldp   x21, x22, [sp, 32]
   ldp   x23, x24, [sp, 48]

   /* Return from towers function */
   ldp x29, x30, [sp], 64  //restore FP and LR, restore SP, deallocate
   ret

//Function main is complete, no modifications needed
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
