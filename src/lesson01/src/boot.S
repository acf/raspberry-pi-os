#include "mm.h"

.section ".text.boot"

.globl _start
_start:
	mrs	x0, mpidr_el1      // move the processor core ID to x0		
	and	x0, x0, #0xFF	   // AND x0 with 0xFF
	cbz	x0, master		   // Branch to Master when its x0 == 0
	b	proc_hang          // otherwise Branch to proc_hang

proc_hang: 
	b 	proc_hang          // Basically an infinite loop for non-primary cores

master:
	adr	x0, bss_begin      // put bss_begin in x0  (see linker.ld)
	adr	x1, bss_end        // put bss_end in x1  (see linker.ld)
	sub	x1, x1, x0         // subtract so x0 now contains begin and x1 contains size
	bl 	memzero            // zero out that range from x0 for x1 bytes (see mm.S)

	mov	sp, #LOW_MEMORY    // move the stack pointer to the LOW_MEMORY address (in mm.h) that will clear the kernel
	bl	kernel_main        // kick off the kernel_main function (in kernel.c)
	b 	proc_hang		   // should never come here



//mrs Load value from a system register to one of the general purpose registers (x0–x30)
//and Perform the logical AND operation. We use this command to strip the last byte from the value we obtain from the mpidr_el1 register.
//cbz Compare the result of the previously executed operation to 0 and jump (or branch in ARM terminology) to the provided label if the comparison yields true.
//b   Perform an unconditional branch to some label.
//adr Load a label's relative address into the target register. In this case, we want pointers to the start and end of the .bss region.
//sub Subtract values from two registers.
//bl  "Branch with a link": perform an unconditional branch and store the return address in x30 (the link register). When the subroutine is finished, use the ret instruction to jump back to the return address.
//mov Move a value between registers or from a constant to a register.