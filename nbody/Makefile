PROGS = \
	nbody-c \
	nbody-d \
	nbody-go \
	nbody-nim \
	nbody-java

BENCHS = $(PROGS:%=bench-%)

TIME = /usr/bin/time
FMT = '{"user":"%U","system":"%S","real":"%E","cpu":"%P","text":%X,"data":%D,"max":%M,"cmd":"%C"}'

all: build

build: $(PROGS)

bench: $(BENCHS)

clean:
	-@rm -f nbody-*
	-@rm -f *.class
	-@rm -rf nimcache

nbody-c: nbody.c
	@gcc -O3 -o $@ $^ -lm

nbody-d: nbody.d
	@gdc -O3 -o $@ $^

nbody-go: nbody.go
	@go build -o $@ $^

nbody-nim: nbody.nim
	@nim c -d:release -o:$@ $^

nbody-java: nbody.class

nbody.class: nbody.java
	@javac $^

bench-nbody-c: nbody-c
	-@$(TIME) -f $(FMT) ./nbody-c 50000000 >/dev/null

bench-nbody-d: nbody-d
	-@$(TIME) -f $(FMT) ./nbody-d 50000000 >/dev/null

bench-nbody-go: nbody-go
	-@$(TIME) -f $(FMT) ./nbody-go 50000000 >/dev/null

bench-nbody-nim: nbody-nim
	-@$(TIME) -f $(FMT) ./nbody-nim 50000000 >/dev/null

bench-nbody-java: nbody-java
	-@$(TIME) -f $(FMT) java -server nbody 50000000 >/dev/null

.PHONY: all build bench clean
.PHONY: nbody-java
.PHONY: $(BENCHS)
