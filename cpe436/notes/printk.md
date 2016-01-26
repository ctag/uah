# Printk

## Usage

printk can be used with or without a prepended loglevel tag.

<pre>
printk("Just put text in dmesg."); // Implements a default loglevel
printk(KERN_INFO "Or set loglevel as well."); // Specifies its own loglevel
</pre>

The list of kernel loglevels are:

Loglevel | Description
---- | ----
KERN_EMERG | An emergency condition. System is likely dead.
KERN_ALERT | A problem that requires immediate attention.
KERN_CRIT | A critical error.
KERN_ERR | An error.
KERN_WARNING | A warning.
KERN_NOTICE | A normal but noteworthy condition.
KERN_INFO | An informational message.
KERN_DEBUG | A debugging message.

List from [makelinux.net](http://www.makelinux.net/books/lkd2/ch18lev1sec3) 

## Log Buffer

printk messages are stored in a circular buffer of size LOG_BUF_LEN. The size can be configured with the CONFIG_LOG_BUF_SHIFT option in `make menu`.

## Syslogd and klogd

syslogd and klogd work together to process kernel printk messages. I need to read up more on them.

## Early Printing

If you use printk too soon, then the output is lost because there is no console yet. If printk messages are lost during early boot, then it may be worthwhile to check out `early_printk()`.

## Links

https://www.kernel.org/doc/Documentation/printk-formats.txt

http://elinux.org/Printk_Times

http://www.makelinux.net/books/lkd2/ch18lev1sec3