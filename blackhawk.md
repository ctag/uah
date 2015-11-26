
### Blackhawk

(AKA 2GB quotas are stupid)

#### List of working software

* Byobu
* tmux
* gnu screen
* openMPI
* htop
* cmake
* ffmpeg
* cmatrix
* gcc-4.7.4 (in /tmp/gcc-4.7.4)
* cloc
* tig

#### List of tried but not working software

* task, but couldn't get cmake working with me
* rtorrent
* qalc (can't find source)
* cowsay (not C based)

#### List of libraries available

* libevents
* gmp
* mpc
* mpfr
* libuuid

#### Usage

To access this software anthology, follow from here:

1. Open your bashrc file:
<pre>
vim ~/.bashrc
</pre>
2. Edit it thusly by appending the following:
<pre>
. /home/student/csb0019/public/software/pathupdate.sh
</pre>
The dot and space at the beginning of the line instruct your shell to "source" my script and execute its contents inline with your bashrc file. My script in turn will append the most up to date path of my software builds to your $PATH variables, which allows you to call programs without full paths.
3. For this to take affect, you must log out and then log back in.
4. If this for some reason fails (likely with a "permission denied" message), copy the error given and email me about it! To check in on how useful this software set is, I do track which users have sourced the above script (it echos your username to a file).

#### Building

To build these programs:

* byobu needs tmux needs libevents
* gcc needs mpc needs mpfr needs gmp

libevents:

<pre>
\# Create a build directory inside of the unpacked source
../configure --prefix=/home/student/csb0019/public/software/libevent/ --disable-static --disable-shared
make
make verify
make install
</pre>

tmux:

<pre>
\# Create a build directory inside of the unpacked source
../configure --prefix=/home/student/csb0019/public/software/tmux/ CFLAGS="-I /home/student/csb0019/software/libevent/include" LDFLAGS="-L/home/student/csb0019/software/libevent/lib"
make
make install
</pre>


byobu:

<pre>
\# Create a build directory inside of the unpacked source
../configure --prefix=/home/student/csb0019/public/software/tmux/
make
make install
</pre>

openMPI:

<pre>
\# Create a build directory inside of the unpacked source
../configure --prefix=/home/student/csb0019/public/software/tmux/
make all
make install
</pre>


pathupdate.sh:

<pre>
export CSB_SOFTWARE=/home/student/csb0019/public/software
PATH=$PATH:$CSB_SOFTWARE/openmpi/bin/:$CSB_SOFTWARE/byobu/bin/:$CSB_SOFTWARE/tmux/bin/
echo "[$USER] $(date)" >> $CSB_SOFTWARE/useage.txt
</pre>

#### Links

* [Building Libevent](http://www.linuxfromscratch.org/blfs/view/svn/basicnet/libevent.html)




