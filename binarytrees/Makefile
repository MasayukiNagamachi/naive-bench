PROGS = \
	binarytrees-c \
	binarytrees-d \
	binarytrees-go \
	binarytrees-java

BENCHS = $(PROGS:%=bench-%)

TIME = /usr/bin/time
FMT = '{"user":"%U","system":"%S","real":"%E","cpu":"%P","text":%X,"data":%D,"max":%M,"cmd":"%C"}'

all: build

build: $(PROGS)

bench: $(BENCHS)

clean:
	-@rm -f binarytrees-*
	-@rm -f *.class

binarytrees-c: binarytrees.c
	@gcc -O3 -o $@ $^

binarytrees-d: binarytrees.d
	@gdc -O3 -o $@ $^

binarytrees-go: binarytrees.go
	@go build -o $@ $^

binarytrees-java: binarytrees.class

binarytrees.class: binarytrees.java
	@javac $^

bench-binarytrees-c: binarytrees-c
	-@$(TIME) -f $(FMT) ./binarytrees-c 20 >/dev/null

bench-binarytrees-d: binarytrees-d
	-@$(TIME) -f $(FMT) ./binarytrees-d 20 >/dev/null

bench-binarytrees-go: binarytrees-go
	-@$(TIME) -f $(FMT) ./binarytrees-go 20 >/dev/null

bench-binarytrees-java: binarytrees-java
	-@$(TIME) -f $(FMT) java -server binarytrees 20 >/dev/null

.PHONY: all build bench clean
.PHONY: binarytrees-java
.PHONY: $(BENCHS)
