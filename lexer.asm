section .data
    LF      equ     10  ; line feed
    NULL    equ     0   ; end of string
    STDOUT  equ     1   ; standard output
    STDIN   equ     0   ; standard input

    SYS_write   equ 1   ; write
    SYS_read    equ 0   ; read

    input   db  "=+(){},;", NULL ; null terminated string input
    newLine db  LF,         NULL ; line feed null - CRLF go away 

    
section .text
    global _start 

_start:
    
    mov rdi, input  
    call printString 

    ; Exit the program
    mov eax, 60            ; sys_exit system call
    xor edi, edi           ; exit code 0
    syscall                ; execute the system call

global TestNextToken
TestNextToken:

    ret

global readChar
readChar:
    
    ; Check if the readPosition is greater than or equal to the length of the
    ; input
    cmp rsi, rdi
    jge readCharDone

    ; Not greater than or equal to the length of the input, set the current
    ; char under examination to null
    readCharDone:
    mov byte[rcx], NULL
    jmp setNextChar

    ; Set the current char under examination to the next char in the input
    setNextChar:
    mov byte[rcx], byte[rsi]
    inc rsi

global NextToken
NextToken:
    ; Get the next char from input
    mov rax, SYS_read
    mov rdi, STDIN
    mov rsi, input
    mov rdx, 1
    syscall

    ; Check if char is an equal sign
    cmp byte[rsi], '='
    je  equal

    ; Check if char is a semicolon
    cmp byte[rsi], ';'
    je  semicolon

    ; Check if char is a left parenthesis
    cmp byte[rsi], '('
    je  leftParenthesis

    ; Check if char is a right parenthesis
    cmp byte[rsi], ')'
    je  rightParenthesis

    ; Check if char is a comma
    cmp byte[rsi], ','
    je  comma
    
    ; Check if char is a plus sign
    cmp byte[rsi], '+'
    je  plus

    ; Check if char is a left brace
    cmp byte[rsi], '{'
    je  leftBrace

    ; Check if char is a right brace
    cmp byte[rsi], '}'
    je  rightBrace

    ; Check if char is a null terminator
    cmp byte[rsi], NULL
    je  null

    ; Check if char is end of file
    cmp byte[rsi], EOF
    je  null




    ; Output the character
    ret


; Arguments:
; 1) address(rdi), string
global printString
printString:

    ; Count chars in string
    mov rbx, rdi
    mov rdx, 0
    
    strCountLoop:
        cmp byte[rbx], NULL
        je strCountDone
        inc rdx
        inc rbx
        jmp strCountLoop 
    strCountDone:
        cmp rdx, 0
        je  printDone

    ; Call OS to output string
    mov rax, SYS_write
    mov rsi, rdi
    mov rdi, STDOUT
    syscall

    printDone:
        ret

