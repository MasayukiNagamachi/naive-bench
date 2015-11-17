DIRS = \
	binarytrees \
	nbody

$(DIRS):
	@$(MAKE) -C $@ $(MAKECMDGOALS)

all: build

build: $(DIRS)

bench: $(DIRS)

clean: $(DIRS)

.PHONY: all build bench clean $(DIRS)
