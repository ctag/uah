using namespace std;

#include <iostream>
#include <stdlib.h>
#include <pthread.h>

int num = 1;

void * thread1 (void * dummy)
{
	num = num + 1;
}

void * thread2 (void * dummy)
{
	num = num * 3;
}

void * thread3 (void * dummy)
{
	num = 123;
}

int main (int argc, char * argv[])
{
	pthread_t thread1_id, thread2_id, thread3_id;

	pthread_create(&thread1_id, NULL, thread1, NULL);
	pthread_create(&thread2_id, NULL, thread2, NULL);
	pthread_create(&thread3_id, NULL, thread3, NULL);

	cout << "num = " << num << endl;

	while(1); // loop
}
