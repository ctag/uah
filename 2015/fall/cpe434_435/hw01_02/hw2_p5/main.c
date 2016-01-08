#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int global_var = 4;

void * doPrint()
{
	printf("\nglobal var address: %d\n", &global_var);
	return NULL;
}

int main()
{
    long thread;
    pthread_t* thread_handles;
    int thread_count = 4;

    thread_handles = malloc(thread_count * sizeof(pthread_t));

    for (thread = 0; thread < thread_count; thread++)
	{
		pthread_create(&thread_handles[thread], NULL, doPrint, (void*) thread);
	}

	for (thread = 0; thread < thread_count; thread++)
	{
		pthread_join(thread_handles[thread], NULL);
	}

	free(thread_handles);

    return 0;
}
