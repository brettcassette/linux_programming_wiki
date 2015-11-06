SOURCES = $(wildcard *.c)
OBJECTS = $(patsubst %.c, %.o, $(SOURCES))

%.o : %.c
	gcc $*.c -o $*.o

all: $(OBJECTS)
