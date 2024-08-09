# main.c -> main
# preload-lib.c -> preload-lib.so

CC = gcc
CFLAGS = -Wall -fPIC -shared
LDFLAGS = -ldl

all: main preload-lib.so

main: main.c
	$(CC) -o $@ $^

main-static: main.c
	$(CC) -o $@ $^ -static

preload-lib.so: preload-lib.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	rm -f main preload-lib.so main-static

.PHONY: all clean

run-preload: all
	@echo "Running main"
	@(export LD_PRELOAD="./preload-lib.so"; ./main)

run: all
	@echo "Running main"
	@./main

readelf:
	readelf -h main
	readelf -h preload-lib.so