// General Bounded Buffer Producer/Consumer Problem
// This program is to dynamically spawn a user defined set
// of producer threads and consumer threads which communicate
// with one another using a circular buffer where the 
// producer thread places its id.
// FILE: bounded_buffer_omp.cpp
 
using namespace std;
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <string.h>
#include <omp.h>
#include <semaphore.h>
#include <unistd.h>


/* Compilation on dmc.asc.edu

  first set up environment by typing from the command line the
  following two module load commands

   module load intel
   requires linking with util.o file at compile time which should 
   be placed in the same directory as bounded_buffer_omp.cpp file

   to compile/link the program with routines in the util.o file type

      icc bounded_buffer.cpp -o bounded_buffer_omp util.o -openmp 

   to run 

     ./bounded_buffer_omp  

*/

// producer/consumer headers for routines
// that are in util.o file
void init_producer(int);
void init_consumer(int);
int produce_next_data_item(int); 
int consume_item(int,int);

// Global Counting Semaphore Declarations
sem_t empty, full;

// Global MUTEX Lock
omp_lock_t mutex;

// producer and consumer slot indices
int con_index=0, prod_index=0;

// Pointer to Shared Buffer used by 
// Producer/Consumer Threads
int *shared_buf;

// major runtime parameters to be obtained from user
int num_producers; // number of producer processes
int num_consumers; // number of consumer processes
int num_items;     // number of data items
int N;             // number of data slots in circular buffer

// SHARED_BUF(x,y) macro
//    where indicies 
//       x = 0 -> id of producer; x = 1 -> data that was produced
//       y = next location in finite bounded buffer 
// This macro is used to represent the dynamically declared region
// of memory pointed to by the globally defined shared_buf varible
// to represent a two-dimensional memory space where the first 
// dimension is of size 2 and the second dimension is equal to the 
// number of entries in the circular buffer as defined at 
// execution time.
#define SHARED_BUF(x,y) (shared_buf[y*2+x])

// global file descriptor for diary file
ofstream diary;  

// routine to ask the user at run time for the number of producer and
// consumer threads, total number of data items to be produced/consumed
// (to be evenly divided among the producer/consumer threads), 
// and the number of entries in the communication buffer
void init_data(int * producers, int * consumers, int * items, int *N) {
   do {
      cout << "Enter Number of Producer Threads to be Spawned:";
      cin >> *producers; 
   } while (*producers < 1);

   do {
      cout << "Enter Number of Consumer Threads to be Spawned:";
      cin >> *consumers;
   } while (*consumers < 1);

   do {
      cout << "Enter the Total Number of Items to be Produced/Consumed:";
      cin >> *items;
   } while (*items < 1);

   do {
      cout << "Enter the Number of Entries present in the Circular Buffer:";
      cin >> *N;
   } while (*N < 1);

   // if present erase file named diary.txt
   diary.open("diary.txt");  
   diary.close();

   // then open the diary.txt file
   // again in append mode
   diary.open("diary.txt",ios::app); 

}

// utility function to convert integers into old style C strings
void int_to_C_string_conv(char * C_str_num, int num) {
   std::string s;
   std::stringstream out;
   out << num;
   s = out.str();
   strcpy(C_str_num,s.c_str());
}

// macro that computes the number of items in the list associated 
// with a particular consumer or producer thread that has the
// specified thread id. It assumes that the data items that 
// are to be processed by the set of threads in each category
// should be as eqaul as possible (most heavily loaded thread
// has at most one more data item than the least heavily loaded
// one).
// inputs: 
//    id:          thread id within the group
//    nm_items:    total number of items in list
//    nm_threads:  total number of threads in the category
// outputs: 
//    if (nm_items%nm_threads) return nm_items/nm_threads + 1; 
//    else return nm_items/nm_threads; 
#define group_sz(id,nm_items,nm_threads) (nm_items/nm_threads+(id<(nm_items%nm_threads)))

void producer(int id) {

   // Create a Separate Producer diary file named prod_{id}.txt
   // for the particular producer that is being referenced 
   char id_string[10]; // C style string rep of the producer id
   char prodfile[20];   // C style file name string
   strcpy(prodfile,"prod_");
   int_to_C_string_conv(id_string,id);
   strcat(prodfile,id_string);  // append producer id to file name
   strcat(prodfile,".txt");     // give it a *.txt extension
   ofstream prod_file(prodfile); // open prod file stream for writing
   // initialize the producer function produce_next_data_item(id) so that
   // it produces consecutively numbered data items for each thread
   // starting at 1 and varies in terms of its execution time in a
   // threadsafe pseudorandom manner.
   init_producer(id);

   for (int i=0;i<group_sz(id,num_items,num_producers);i++) { 
      // produce the next data item -- not in critical section
      // This could take varing amounts of time
      int new_data =  produce_next_data_item(id);

      // add semaphore synchronization
      // enter your code here!!!

      // set omp lock variable -- enter critical section
      omp_set_lock(&mutex);
      // Critical Region of Code where produced item is placed in
      // next slot of buffer and global producer index is 
      // incremented by one in a modulo manner

      cout << "Hello from Producer " << id << endl << flush;

      // place data into shared buffer
      // data includes producer ID & data
      SHARED_BUF(0,prod_index)=id;       // producer ID
      SHARED_BUF(1,prod_index)=new_data; // produced data
      cout << "Hello from Producer " << id << endl << flush;
      // log activity in common diary file  
      diary << "Producer" << id << " placed data [" << SHARED_BUF(1,prod_index) <<
            "] in buffer slot(" << prod_index << ")" << endl << flush;

      // also log activity in local prod file
      prod_file << "Producer" << id << " placed data [" << SHARED_BUF(1,prod_index)
             << "] in buffer slot(" << prod_index << ")" << endl;

      /* increment prod_index to point to next slot */
      prod_index = (prod_index+1)%N;

      // reset omp lock variable
      omp_unset_lock(&mutex);

      // add appropriate semaphore synchronization
      // enter your code here!!!
   }
   // close the producer file
   prod_file.close();
}

void consumer(int id) {

   // Create a Separate Consumer diary file named con_{id}.txt
   // for the particular consumer that is being referenced 
   char id_string[10]; // C style string rep of the consumer id
   char confile[20];   // C style file name string
   strcpy(confile,"con_");
   int_to_C_string_conv(id_string,id);
   strcat(confile,id_string);  // append consumer id to file name
   strcat(confile,".txt");     // give it a *.txt extension
   ofstream con_file(confile); // open con file stream for writing

   // initialize the consumer function consume_item(data) so that
   // it varies in time in a threadsafe pseudorandom manner.
   init_consumer(id);
   for (int i=0;i<group_sz(id,num_items,num_consumers);i++) { 

      // add semaphore synchronization
      // enter your code here!!!

      omp_set_lock(&mutex);
      // Critical Region of Code where produced item is consumed from
      // next slot of buffer and global consumer index is incremented by one
      // in a modulo manner

      cout << "Hello from Consumer " << id << endl << flush;

      // get data from shared buffer
      // data includes producer ID & data
      int prod_id  =SHARED_BUF(0,con_index); // producer ID
      int prod_data=SHARED_BUF(1,con_index); // produced data

      // log activity in common diary file
      diary << "Consumer" << id << " Received Producer" << prod_id <<
            "'s data item [" << prod_data << "] via the buffer slot ("
            << con_index << ")" << endl << flush;

      // also log activity in local con file
      con_file << "Consumer" << id << " Received Producer" << prod_id <<
               "'s data item [" << prod_data << "] via the buffer slot ("
               << con_index << ")" << endl;

      // increment con_index to point to next slot in buffer
      // wrapping back arround to 0 at the end of the buffer region
      con_index = (con_index+1)%N;

      // reset omp lock variable
      omp_unset_lock(&mutex);

      // add semaphore synchronization
      // enter your code here!!!

      // while outside of the critical area consumer thread
      // consumes the data item in a meaningfull way
      // This could take varing amounts of time
      consume_item(prod_data,id);
   }

   // close the consumer file
   con_file.close();
}

int main (int argc, char *argv[]) {

   // prompt user for number of producers, consumers,items,
   //  and buffer size
   init_data(&num_producers, &num_consumers, &num_items,&N);

   // initialize shared memory region
   shared_buf = new int[N*2];


   // initializing standard OpenMP MUTEX Variable
   omp_init_lock(&mutex);

   // initalize Counting Semaphores, full & empty
   // enter your code here!!!
   // enter your code here!!!

   // Spawn Consumer/Producer Threads
   //  Case 1) using simple work sharing data parallel constructs
   //          enter your code here
   //  Case 2) using OpenMP's tasking model
   //          enter your code here

   // destroying standard OpenMP MUTEX Variable
   omp_destroy_lock(&mutex);

   // destroy semaphores full & empty
   // enter your code here!!!
   // enter your code here!!!

   // close diary.txt file
   diary.close();
}

