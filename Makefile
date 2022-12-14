NAME		:= exe
MACHO		:= bin.macho
ASM			:= srcs/asm/execve_cmd.s
CC			:= gcc
LFLAGS		:= -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path`
CFLAGS		:= -Wall -Wextra -Werror

C_SRCS		:=		\
	srcs/arm64e_loader.c	\

all: $(MACHO)

asm.o: $(ASM)
	as $< -o asm.o

$(MACHO): asm.o
	ld $(LFLAGS) $< -o $@ 

exec:
	$(CC) $(CFLAGS) $(C_SRCS) -I./incs -o $(NAME)

clean:
	rm -f *.o

fclean: clean
	rm -f $(NAME)
	rm -f $(MACHO)
	rm -rf $(NAME).dSYM

re: fclean all

.PHONY	: all sc clean exec fclean re
