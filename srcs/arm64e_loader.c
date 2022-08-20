#include <sys/mman.h>
#include <stdbool.h>
#include <string.h>

const char __sc[64] =
"\xe0\x45\x8c\xd2"	 //   mov   x0, #25135
"\x20\xcd\xad\xf2"	 //  movk   x0, #28265, lsl #16
"\xe0\x65\xce\xf2"	 //  movk   x0, #29487, lsl #32
"\x00\x0d\xe0\xf2"	 //  movk   x0, #104, lsl #48
"\xe0\x0f\x1c\xf8"	 //   str   x0, [sp, #-64]!
"\xe0\x03\x00\x91"	 //   mov   x0, sp
"\xa1\x65\x8c\xd2"	 //   mov   x1, #25389
"\xe1\x0b\x00\xf9"	 //   str   x1, [sp, #16]
"\xe1\x43\x00\x91"	 //   add   x1, sp, #16
"\xe2\x00\x00\x10"	 //   adr   x2, #28
"\xe0\x07\x02\xa9"	 //   stp   x0, x1, [sp, #32]
"\xe2\x7f\x03\xa9"	 //   stp   x2, xzr, [sp, #48]
"\xe2\x03\x1f\xaa"	 //   mov   x2, xzr
"\xe1\x83\x00\x91"	 //   add   x1, sp, #32
"\x70\x07\x80\xd2"	 //   mov   x16, #59
"\x01\x00\x00\xd4";	 //   svc   #0

const char __buffer[192];

static bool	__run(char *cmd)
{
	int		(*ptr)(void);
	void	*buf;
	size_t	sc_len;
	size_t	buf_len;

	sc_len = sizeof(__sc);
	buf_len = sizeof(__buffer);
	if (strlen(cmd) >= buf_len)
		return (false);
	strlcpy((char *)__buffer, cmd, buf_len);
	buf = mmap(0, 256, PROT_WRITE | PROT_READ, MAP_ANON | MAP_PRIVATE, -1, 0);
	if (buf != MAP_FAILED)
	{
		ptr = memcpy(buf, __sc, sc_len + buf_len);
		if (mprotect(buf, 256, PROT_EXEC | PROT_READ) == 0)
			return (ptr());
	}
	return (false);
}

int	main(int ac, char **av)
{
	(void)ac;
	(void)av;
	return (__run("(echo hello world | rev) | cat -e"));
}