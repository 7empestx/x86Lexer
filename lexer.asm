section .data
    EOF     equ     -1  ; end of file

    SYS_write   equ 1   ; write
    SYS_read    equ 0   ; read
    ;  Define standard constants.

    TRUE            equ     1
    FALSE           equ     0

    LF              equ     10
    NULL            equ     0

    SUCCESS         equ     0                       ; successful operation
    NOSUCCESS       equ     1

    STDIN           equ     0                       ; standard input
    STDOUT          equ     1                       ; standard output
    STDERR          equ     2                       ; standard error

    SYS_read        equ     0                       ; code for read
    SYS_write       equ     1                       ; code for write
    SYS_open        equ     2                       ; code for file open
    SYS_close       equ     3                       ; code for file close
    SYS_fork        equ     57                      ; code for fork
    SYS_exit        equ     60                      ; code for terminate
    SYS_creat       equ     85                      ; code for file open/create
    SYS_time        equ     201                     ; code for get time

    input   db  "=+(){},;", NULL ; null terminated string input
    newLine db  LF,         NULL ; line feed null - CRLF go away 

    
section .text
    global _start 

_start:
    
    mov rdi, input  
    call printString

    mov rdi, input
    mov rsi, 0
    mov rdx, 0
    mov rcx, 0
    mov r8, 0
    call readChar

    ; Exit the program
    ; mov eax, 60            ; sys_exit system call
    ; xor edi, edi           ; exit code 0
    ; syscall                ; execute the system call
    last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall

global TestNextToken
TestNextToken:
    ret

; Arguments: 
; input:        string  (rdi)
; position:     int     (rsi) current position in input (points to current char)
; readPosition: int     (rdx) current read position in input (after current char)
; ch:           char    (rcx) current char under examination
; inputLength:  int     (r8)  length of input
global readChar
readChar:
    push    rbx
    push    r12
    push    r13
    ; if l.readPosition >= len(l.input) { l.ch = 0 }
    cmp rdx, r8
    jge readInputDone

    ; else { l.ch = l.input[l.readPosition] }
    mov rcx, 0
    mov cl, byte[rdi + rdx]
    jmp readCharDone

    readInputDone:
        ; l.ch = 0
        mov rcx, 0
    
    readCharDone:
        ; l.position = l.readPosition
        mov rsi, rdx
        ; l.readPosition += 1
        ; this will globally update the variable inside
        ; the register rbx
        ; if you want to update a variable in a register, use
        ; memory addressing
        inc dword[rdx]

    pop r13
    pop r12
    pop rbx
    ret

global NextToken
NextToken:
    ; Get the next char from input
    mov rax, SYS_read
    mov rdi, STDIN
    mov rsi, input
    mov rdx, 1
    syscall

    ; USE ASCII VALUES GRANT !!!!!!!!

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

    equal:
    semicolon:
    leftParenthesis:
    rightParenthesis:
    comma:
    plus:
    leftBrace:
    rightBrace:
    null:
        ret




    ; Output the character
    ret


; Arguments:
; 1) address(rdi), string
global printString
printString:
    push    rbp
    mov    rbp, rsp
    push    rbx
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
    pop rbx
    pop rbp
        ret

; Arguments:
; 1) address(rdi), string
global getStringLength
getStringLength:
; integer returning function that returns the string length???
;  string length return in rax
    push    rbx
    push    r12
    push    r13
    ; Count chars in string
    mov rbx, rdi
    ; mov r13, 0
    ; used rax instead so that this function will return str length
    ; used like x = getStringLength
    mov rax, 0
    myStrCountLoop:
        cmp byte[rbx], NULL
        je strCountDone
        inc rax
        inc rbx
        jmp myStrCountLoop 
    myStrCountDone:
    pop r13
    pop r12
    pop rbx
        ret


; exits the program. put it here just in case you need it

