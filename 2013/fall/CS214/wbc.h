/**
  * @description - Buffer Controller
  * By: Christopher Bero - 2013
  * 
  * Provides tools to clear the standard input buffer
  */

#include <stdlib.h>
#include <iostream>
#include <string>

bool bcFlush(){
    bool flushed = std::cin.good();
    std::cin.clear();
    std::cin.sync();
    return flushed;
}

bool bcFlush(char cmd[]){
    bool flushed = std::cin.good();
    std::cin.clear();
    std::cin.sync();

    system(cmd);
    
	return flushed;
}

bool bcFlush(char cmd[], std::istream &stream){
    bool flushed = stream.good();
    stream.clear();
    stream.sync();

    system(cmd);

    return flushed;
}