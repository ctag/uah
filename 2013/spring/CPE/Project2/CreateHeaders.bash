#!/bin/bash
if [ -e Cpp_header.cpp ] 
then

  if [ -e a.out ]
  then
    rm a.out
  fi
  OSNAME=`uname -s`
  if [ $OSNAME == "SunOS" ]
  then
      CC Cpp_header.cpp
  elif [ $OSNAME == "Linux" ]
  then
      g++ Cpp_header.cpp
  else
      echo "machine OS ($OSNAME) not recognized. contact TA"
	  exit
  fi
  if [ -e a.out ]
  then
    rm a.out
    for x in `ls `
    do
      if [ -d $x ]
      then
	    echo "Copying Cpp_header.cpp to directory $x"
        cp Cpp_header.cpp $x/$x.cpp
      fi
    done
  else
	  echo "The File Cpp_header.cpp does not compile."
	  echo "Fix the problems and run this script again."
  fi
else
  echo "The file Cpp_header.cpp does not exist."
  echo "Correct this problem and run the script again"
fi

