#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

#define SERVER_PORT 2016
#define MAX_LINE 256

int main(int argc, char * argv[])
{
    FILE *fp;
    struct hostent *hp;
    struct sockaddr_in sin;
    char * host;
    char buf[MAX_LINE];
    int s;
    int len;

    if (argc == 2)
	{
		host = argv[1];
	}
	else
	{
		fprintf(stderr, "usage: simplex-talk host\n");
		exit(1);
	}

	// Host name to peer ip address
	hp = gethostbyname(host);
	if (!hp)
	{
		fprintf(stderr, "simplex-talk: unknown host: %s\n", host);
		exit(1);
	}

	// Build address data structure
	bzero((char *)&sin, sizeof(sin));
	sin.sin_family = AF_INET;
	bcopy(hp->h_addr, (char *)&sin.sin_addr, hp->h_length);
	sin.sin_port = htons(SERVER_PORT);

	// active open
	if ((s = socket(PF_INET, SOCK_STREAM, 0)) < 0)
	{
		perror("simplex-talk: socket");
		exit(1);
	}
	if (connect(s, (struct sockaddr *)&sin, sizeof(sin)) < 0)
	{
		perror("simplex-talk: connect");
		close(s);
		exit(1);
	}

	// main loop
	while (fgets(buf, sizeof(buf), stdin))
	{
		buf[MAX_LINE-1] = '\0';
		len = strlen(buf) + 1;
		//printf("Sending [%s] to server.", buf);
		send(s, buf, len, 0);
	}

    return 0;
}















