# Creating a System Call

## Method 1

Works on:
* 2.6.11

### Modify system call table entry

Add your system call to the end of the list in `arch/i386/kernel/entry.S`

The entry will take the form:
<pre>
	.long sys_bero_test
</pre>

Next create a system call stub in `include/asm-i386/unistd.h`

The entry will take the form:
<pre>
    #define __NR_bero_test		289
</pre>

### Create source files

I place mine in a top level directory called `bero`

This takes three files:

`bero/test.c`
<pre>
#include "test.h"
#include <linux/kernel.h> /* for printk */

asmlinkage long sys_bero_test (int arg1) {
	printk(KERN_INFO "bero_test system call.");
    return(arg1 + 1);
}
</pre>

`bero/test.h`
<pre>
#ifndef __LINUX_BERO_TEST_H
#define __LINUX_BERO_TEST_H

#include <linux/unistd.h>
#include <linux/linkage.h>

_syscall1(long, bero_test, int, arg1);

#endif
</pre>

`bero/Makefile`
<pre>
obj-y := bero_test.o
</pre>

### Create C program

Now you have to interact with the system call from userspace.

`main.c`
<pre>
#include <stdio.h>
#include <linux/kernel.h>
#include <sys/syscall.h>
#include <unistd.h>
 
#define __NR_bero_test 289 //349 if you are running a 32bit kernel and following my tutorial
 
long hello_syscall(void)
{
            return syscall(__NR_bero_test, 4);
}
 
int main(int argc, char *argv[])
{
        long int a = hello_syscall();
        printf("System call returned %ld\n", a);
        return 0;
}
</pre>

## Links

http://www.csee.umbc.edu/courses/undergraduate/CMSC421/fall02/burt/projects/howto_add_systemcall.html

https://github.com/0xAX/linux-insides/blob/master/SysCall/syscall-1.md

https://arvindsraj.wordpress.com/2012/10/05/adding-hello-world-system-call-to-linux/

http://www.makelinux.net/books/lkd2/?u=ch18lev1sec3

