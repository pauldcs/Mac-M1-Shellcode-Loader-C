#include <sys/mman.h>
#include <sys/wait.h>
#include <stdbool.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

char	__sc[] = 
{
	0xa0, 0x00, 0x00, 0x10,
	0xe1, 0x03, 0x1f, 0xaa,
	0xe2, 0x03, 0x1f, 0xaa,
	0x70, 0x07, 0x80, 0xd2,
	0x01, 0x00, 0x00, 0xd4,

	'/',  'b',  'i',  'n',
	'/',  's',  'h',  0x00
};

static void	execute(void)
{
	int		(*ptr)(void);
	void	*buf;

	buf = mmap(0, 0x1000, PROT_WRITE | PROT_READ, MAP_ANON | MAP_PRIVATE, -1, 0);
	if (buf != MAP_FAILED) {
		ptr = memcpy(buf, __sc, sizeof(__sc));
		if (mprotect(buf, 0x1000, PROT_EXEC | PROT_READ) == 0)
			ptr();
	}
}

int	__load(void)
{
	pid_t	id;
	int		ret;
	
	id = fork();
	if (id < 0)
		return (EXIT_FAILURE);
	else if (id == 0)
	{
		execute();
		exit(EXIT_FAILURE);
	}
	waitpid(id, &ret, 0);
	printf ("%d: Returned %d\n", id, ret);	
	return (ret);
}
