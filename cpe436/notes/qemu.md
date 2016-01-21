# QEMU


## Usage


### Links

http://nairobi-embedded.org/qemu_monitor_console.html

http://www.noah.org/wiki/Disk_mounting

https://en.wikibooks.org/wiki/QEMU/Monitor

https://wiki.archlinux.org/index.php/QEMU#Creating_new_virtualized_system


## Serial Console (+ Grub)

with some configuration, the system can work favorably from ssh. These are the settings for use with Debian Sarge (3). Mind you, we're working with Grub 0.97 (v1).

In `/boot/grub/menu.lst`

<pre>
# Enable console output
serial --unit=0 --speed=9600 --word=8 --parity=no --stop=1
terminal --timeout=15 serial console
</pre>

Make sure to run `sudo update-grub` afterwards.

In `~/.bashrc`

<pre>
PATH=$PATH:/sbin # Get access to root level commands
LESS="${LESS} -R" # Get less to handle color chars right
stty rows 40 # Chosen to work with my laptop's screen
stty cols 120 # Can also be tweaked
</pre>

In `/etc/inittab` near the bottom

<pre>
S0:23:respawn:/sbin/getty -L ttyS0 9600
</pre>

Make sure this line is uncommented. Notice that there's no `vt100` at the end of the line, this is to get some nicer special-character support through the ssh connection.

Make sure to append `--nographic` to any qemu command.

### Links

https://help.ubuntu.com/community/SerialConsoleHowto

https://www.debian-administration.org/article/221/Question_Install_Debian_using_a_serial_console

http://www.tldp.org/LDP/sag/html/config-init.html

https://wiki.archlinux.org/index.php/working_with_the_serial_console#GRUB_v1_and_No_systemd

http://www.tldp.org/HOWTO/Remote-Serial-Console-HOWTO/configure-boot-loader-grub.html

http://linux.koolsolutions.com/2009/03/29/howto-redirecting-linux-console-output-over-serial-port-on-another-machine/

http://serverfault.com/questions/471719/how-to-start-qemu-directly-in-the-console-not-in-curses-or-sdl

https://www.debian.org/releases/stable/i386/ch05s03.html.en

http://kb.digium.com/articles/FAQ/How-to-disable-the-Linux-frame-buffer-if-it-s-causing-problems

http://current.workingdirectory.net/posts/2009/installing-debian-using-qmu/

http://www.dedoimedo.com/computers/grub-2.html#mozTocId232162

