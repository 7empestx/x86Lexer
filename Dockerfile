# Latest Ubuntu image
FROM ubuntu:latest

# Make a working directory
WORKDIR /deez

# Basic system-level dependencies
RUN apt-get update && \
    apt install -y software-properties-common git curl build-essential && \
    add-apt-repository --yes ppa:neovim-ppa/unstable && \
    apt-get install -y neovim

COPY lexer.asm .

# Commands for docker run
CMD make fmt && \
    make lint && \
    make test && \
    make build && \
    make run

CMD nasm -f elf64 lexer.asm -o lexer.o && \
    ld -m elf_i386 lexer.o -o lexer && \
    ./lexer


