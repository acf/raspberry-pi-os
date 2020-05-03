#include "mm.h"

// ---------------------------------------------------------------------------------------
// create a barrier we can hold on and signal so that 1 core inits memory and others wait.
// ---------------------------------------------------------------------------------------
.data
barrier: .byte 0
         .align 2
         
         
// ---------------------------------------------------------------------------------------
// now the work      
// ---------------------------------------------------------------------------------------
   
.section ".text.boot"

.globl _start
_start:
	mrs	x0, mpidr_el1      // move the processor core ID to x0		
	and	x0, x0, #0xFF	   // AND x0 with 0xFF
	cbz	x0, bss_init	   // Branch to init the BSS when core 0
	b	wait               // other cores wait



bss_init:
	adr	x0, bss_begin      // put bss_begin in x0  (see linker.ld)
	adr	x1, bss_end        // put bss_end in x1  (see linker.ld)
	sub	x1, x1, x0         // subtract so x0 now contains begin and x1 contains size
	bl 	memzero            // zero out that range from x0 for x1 bytes (see mm.S)

	// Tell other CPU that BSS is ready by sticking a #1 in =barrier
	mov w0, #1
	ldr x1, =barrier
	strb w0, [x1]
	b master

master:
	// PROCESSOR ID in x1
	mrs x1, mpidr_el1
	and x1, x1, #0xFF

	// Use the CPU ID to determine the stack location: 
	// CPU #0: sp = 1 * #LOW_MEMORY, CPU #1: sp = 2 * #LOW_MEMORY, etc
	mov	x0, #LOW_MEMORY 
		
	add x1, x1, #1  // increment ProcID so Proc0 = 1, Proc1 = 2 etc
	mul x0, x0, x1  // Multiply Proc by LOW_MEMORY
	mov sp, x0      // Move to x0
	bl	kernel_main // kick off the kernel_main function (in kernel.c)
	b 	proc_hang	// should never come here

wait:
	// Look for a 1 in =barrier
	ldr x1, =barrier
	ldrb w0, [x1]
	cmp w0, #1
	beq master   // found a #1, branch to master
	b wait       // no 1 yet, just loop

proc_hang: 
	b 	proc_hang          // Basically an infinite loop for non-primary cores
