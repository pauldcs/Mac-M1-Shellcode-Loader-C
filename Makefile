NAME		:= exe
MACHO		:= bin.macho
CC			:= gcc
LFLAGS		:= -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -arch arm64
CFLAGS		:= -Wall -Wextra -Werror

C_SRCS		:=		\
	srcs/main.c		\
	srcs/loader.c	\

all: $(MACHO)

asm.o: srcs/asm/minishell.s
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

.PHONY	: all sc clean fclean re
