// Printf.h header file

#include <stdarg.h>
#include "sw_serial.h"

#ifndef PRINTF_H_
#define PRINTF_H_
void printf(char *, ...);
static void xtoa(unsigned long x, const unsigned long *dp);
static void puth(unsigned n);
#endif /* PRINTF_H_ */
