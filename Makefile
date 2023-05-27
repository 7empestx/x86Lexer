##
# Static part, don't change these:
##

help:
	@cat Makefile | grep -E "^\w+$:"

ready: fmt lint test

docker-build:
	docker build --no-cache . -t deez_$(notdir $(shell pwd))

docker-ready: docker-build
	docker run -v $(shell pwd):/deez -t deez_$(notdir $(shell pwd))

##
# Update those:
##

fmt:
	@echo "===> Formatting"
	# TODO: add yours

lint:
	@echo "===> Linting"
	# TODO: add yours

test:
	@echo "===> Testing"
	./lexer

build:
	@echo "===> Building"
	nasm -f elf64 lexer.asm -o lexer.o
	ld lexer.o -o lexer

run:
	@echo "===> Running"
	./lexer
