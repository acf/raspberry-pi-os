.globl memzero
memzero:
	str xzr, [x0], #8  //store ZERO in whatever address is in x0 and increment that address by 8
	subs x1, x1, #8    //subtract 8 from x1 and store back in x1
	b.gt memzero       //if we just stored a number greater than zero, call ourselves again 
	ret				   //otherwise we're done, return.
