#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

#define SERVER_PORT 2016
#define MAX_PENDING 1
#define MAX_LINE 256

int main(int argc, char * argv[])
{
    struct sockaddr_in sin;
    char buf[MAX_LINE];
    int s, new_s;
    int len;

	// Build address data structure
	bzero((char *)&sin, sizeof(sin));
	sin.sin_family = AF_INET;
	sin.sin_addr.s_addr = INADDR_ANY;
	sin.sin_port = htons(SERVER_PORT);

	// setup passive open
	if ((s = socket(PF_INET, SOCK_STREAM, 0)) < 0)
	{
		perror("simplex-talk: socket");
		exit(1);
	}

	if ((bind(s, (struct sockaddr *)&sin, sizeof(sin))) < 0)
	{
		perror("simplex-talk: bind");
		exit(1);
	}
	listen(s, MAX_PENDING);

	// main loop
	while (1)
	{
		if ((new_s = accept(s, (struct sockaddr *)&sin, &len)) < 0)
		{
			perror("simplex-talk: accept");
			printf("\nsimplex-talk: accept");
			exit(1);
		}
		while ((len = recv(new_s, buf, sizeof(buf), 0)) > 0)
		{
			fputs(buf, stdout);
			send(new_s, buf, len, 0);
		}
		close(new_s);
	}

    return 0;
}















