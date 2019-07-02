OUT = lexprofanity.exe

SOURCE_DIR = $(CURDIR)
CFLAGS = -g -o
LFLAGS = -lfl
CC = gcc

$(OUT):
	$(CC) $(CFLAGS) $(OUT) lex.yy.c -L /usr/bin/ld $(LFLAGS)

clean:
	rm ./lex.yy.c
	rm -rf $(OUT)
