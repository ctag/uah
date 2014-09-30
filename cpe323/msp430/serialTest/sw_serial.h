
#ifndef _MSPEAK_H_
#define _MSPEAK_H_
void init_serial(unsigned txPinMask, unsigned rxPinMask, unsigned bitDuration);
int getchar(void);
int putchar(int c);
int puts(const char *s);
#endif /* _MSPEAK_H_ */

